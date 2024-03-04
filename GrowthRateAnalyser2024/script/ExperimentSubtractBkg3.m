function [Data,experiment] = ExperimentSubtractBkg3(experiment,bkg,nomean,bkg_subract,time_unit,file_excel)

if size(experiment.filenames,1) > size(experiment.tin,1)
    for l=2:size(experiment.filenames,1)
        experiment.tin{l}=experiment.tin{1};
        experiment.tfin{l}=experiment.tfin{1};
    end
end

%loop over files
for i=1:size(experiment.filenames,1)
    T0 = xlsread(experiment.filenames{i});

    %tin
    if isempty(experiment.tin{i})
        experiment.tin{i} = 1;
    end

    %tfin
    if isempty(experiment.tfin{i})
        experiment.tfin{i} = size(T0,1);
    end

    %check time
    if bkg_subract==1
        if experiment.tin{i} ~= bkg.tinOld{1}
            fprintf('Error: initial time of experiment and bkg are different!\n')
        end
    end

    %time
    experiment.time{i} = T0(experiment.tin{i}:experiment.tfin{i},1);

    if bkg_subract==0
        bkg.time{1} = 0.*experiment.time{1};
        bkg.fitStd = 0.*experiment.time{1};
        bkg.fit = 0.*experiment.time{1};
    end

    %raw data
    if experiment.tin{i}>1
        experiment.time{i} = experiment.time{i}-experiment.time{i}(1);
    end
    experiment.raw{i} = T0(experiment.tin{i}:experiment.tfin{i},experiment.wells{i}+1); %+1 because the first column is the time column
end

%find minimal tfin
tfinF = min(cellfun(@numel, experiment.time));

for i=1:size(experiment.filenames,1)
    experiment.time{i} = experiment.time{i}(1:tfinF);
    experiment.raw{i} = experiment.raw{i}(1:tfinF,:);
    experiment.tinOld{i}=experiment.tin{i};
    experiment.tin{i}=1;
    experiment.tfin{i}=tfinF;
end

%reshape vector
% %val_count = sum(cellfun(@numel, experiment.wells));
% expR = [];%zeros(size(experiment.time{1},1),val_count);
% for i=1:size(experiment.raw,1)
%     expR = [expR,experiment.raw{i}];
% end

expR = cell2mat(experiment.raw);

%convert time
if bkg.minut ==1
    convert = 1/60;
elseif bkg.minut==2
    convert = 1/3600;
else
    convert = 1;
end

%plot
figure
hold on
for i=1:size(expR,2)
    scatter(convert.*(experiment.time{1}),expR(:,i),20,'filled');
    plot(convert.*(experiment.time{1}),expR(:,i));
end
set(gca,'YScale','log');
if bkg.minut==1
    xlabel('Time [min]')
elseif bkg.minut==2
    xlabel('Time [hours]')
else
    xlabel('Time [sec]')
end
xlabel('Time [sec]')
ylabel('OD')
title('Raw data')
grid on
box on
axis tight

%mean and std
if nomean == 0
    if size(expR,2)>1
        %[experiment.rawmean,experiment.rawstd] = MeanAndPlot(experiment.time{1},expR);
        [experiment.rawmean,experiment.rawstd] = MeanAndPlotConvert(experiment.time{1},expR,bkg.minut);
    else
        experiment.rawmean = experiment.raw{1};
        experiment.std = [];
        experiment.rawstd = [];

        %convert time
        if bkg.minut ==1
            convert = 1/60;
        elseif bkg.minut==2
            convert = 1/3600;
        else
            convert = 1;
        end

        %plot
        figure
        scatter(convert.*(experiment.time{1}),experiment.rawmean,10,'filled');
        set(gca,'YScale','log');
        if bkg.minut==1
            xlabel('Time [min]')
        elseif bkg.minut==2
            xlabel('Time [hours]')
        else
            xlabel('Time [sec]')
        end
        xlabel('Time [sec]')
        ylabel('OD')
        title('Mean OD')
        grid on
        box on
        axis tight

    end
else
    experiment.rawmean = experiment.raw;
    experiment.std = [];

end

if nomean == 0
    %extend bkg to the needed time tfin of experiment
    if size(bkg.time{1},1) ~= size(experiment.time{1},1)
        fprintf('Error: difference of time in bkg and exp! Fixing it...\n')
        if size(experiment.time{1},1) < size(bkg.time{1},1)
            tf = size(experiment.time{1},1) ;
            bkg.fit = bkg.fit(1:tf);
            bkg.fitStd = bkg.fitStd(1:tf);
            for l=1:size(bkg.time,2)
                bkg.time{l} = bkg.time{l}(1:tf);
            end
        else
            tf = size(bkg.time{1},1) ;
            experiment.rawmean = experiment.rawmean(1:tf);
            experiment.rawstd = experiment.rawstd(1:tf);
            for l=1:size(experiment.time,2)
                experiment.time{l} = experiment.time{l}(1:tf);
            end
        end
        %     if ~isempty(bkg.k0)
        %         bkg.fit = ModelK(experiment.time{1},parameters0);
        %     else
        %         bkg.fit = ModelN(experiment.time{1},parameters0);
        %     end
    end

    %subtract mean
    experiment.mean = experiment.rawmean-bkg.fit;

    %find std
    if isempty(experiment.rawstd)==1
        experiment.std = bkg.fitStd;
    else
        experiment.std = sqrt((experiment.rawstd).^2 + (bkg.fitStd).^2);
    end
else

    experiment.mean = experiment.rawmean{1};
end
%remove negative data
experiment.mean(experiment.mean<0)=0;

%smooth data
if ~isempty(experiment.smoothstrength)
    experiment.mean = smoothdata(experiment.mean,"movmedian",experiment.smoothstrength);
end

%convert time
if bkg.minut ==1
    convert = 1/60;
elseif bkg.minut ==2
    convert = 1/3600;
else
    convert = 1;
end

if nomean == 0
    %plot
    figure
    scatter(convert.*(experiment.time{1}),experiment.rawmean,10,'k','filled');
    hold on
    if ~isempty(experiment.rawstd)
        shadedErrorBar(convert.*(experiment.time{1}),experiment.rawmean,experiment.rawstd,'lineProps','k');
    end
    scatter(convert.*(experiment.time{1}),bkg.fit,10,'r','filled');
    if ~isempty(experiment.rawstd)
        shadedErrorBar(convert.*(experiment.time{1}),bkg.fit,bkg.fitStd,'lineProps','r');
    end
    scatter(convert.*(experiment.time{1}),experiment.mean,10,'g','filled');
    plot(convert.*(experiment.time{1}),experiment.mean,'-','LineWidth',1,'Color','g');
    if ~isempty(experiment.std)
        shadedErrorBar(convert.*(experiment.time{1}),experiment.mean,experiment.std,'lineProps','g');
    end
    if time_unit==1
        xlabel('Time [min]')
    elseif time_unit==2
        xlabel('Time [hours]')
    else
        xlabel('Time [sec]')
    end
    % xlabel('Time [sec]')
    ylabel('OD')
    title('Background subtraction')
    set(gca,'FontSize',20)
    %set(gca,'YScale','log');
    grid on
    box on
    axis tight
end

%import and store data
Data = struct();
Data.time = experiment.time{1};
Data.Xbkg = bkg.fit;
Data.Xbkgstd = bkg.std;
Data.XmeanRaw = experiment.rawmean;
Data.XmeanSmooth = experiment.mean;
Data.Xmean = experiment.mean;
Data.Xstd = experiment.std;

if nomean == 1

    %bkg subtract every plot
    for i=1:size(expR,2)
        Data.XRawNoBkg(:,i) = expR(:,i)-bkg.fit;
        expRT(:,i) = expR(:,i)-bkg.fit;
        Data.XRawNoBkgStd(:,i) = bkg.fitStd;
    end

    %plot
    figure
    hold on
    for i=1:size(expRT,2)
        scatter(convert.*(experiment.time{1}),expRT(:,i),20,'filled');
        %plot((experiment.time{1})./60,expRT(:,i));
        shadedErrorBar(convert.*(experiment.time{1}),expRT(:,i),Data.XRawNoBkgStd(:,i),'lineProps','k');
    end
    %set(gca,'YScale','log');
    if time_unit==1
        xlabel('Time [min]')
    elseif time_unit==2
        xlabel('Time [hours]')
    else
        xlabel('Time [sec]')
    end
    ylabel('OD')
    title('Background subtracted mean')
    grid on
    box on
    axis tight

end

%save to file
if ~isempty(file_excel)
    if nomean == 1
        A = [Data.time,Data.XRawNoBkg];
        writematrix(A,file_excel,'Sheet',1)
        A = [Data.time,Data.XRawNoBkgStd];
        writematrix(A,file_excel,'Sheet',2)
    else
        A = [Data.time,Data.Xmean];
        writematrix(A,file_excel,'Sheet',1)
        A = [Data.time,Data.Xstd];
        writematrix(A,file_excel,'Sheet',2)
    end

end

end