function [Data,experiment] = ExperimentSubtractBkg(experiment,bkg)

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
    if experiment.tin{i} ~= bkg.tinOld{i}
        fprintf('Error: initial time of experiment and bkg are different!\n')
    end

    %time
    experiment.time{i} = T0(experiment.tin{i}:experiment.tfin{i},1);

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

%plot
figure
hold on
for i=1:size(expR,2)
    scatter((experiment.time{1})./60,expR(:,i),20,'filled');
    plot((experiment.time{1})./60,expR(:,i));
end
set(gca,'YScale','log');
xlabel('Time')
ylabel('OD')
grid on
box on
axis tight

%mean and std
if size(expR,2)>1
    [experiment.rawmean,experiment.rawstd] = MeanAndPlot(experiment.time{1},expR);
else
    experiment.rawmean = experiment.raw{1};
    experiment.std = [];

    %plot
    figure
    scatter(experiment.time{1},experiment.rawmean,10,'filled');
    set(gca,'YScale','log');
    xlabel('Time')
    ylabel('OD')
    grid on
    box on
    axis tight

end

%extend bkg to the needed time tfin of experiment
if bkg.time{1} ~= experiment.time{1}
    fprintf('Error: difference of time in bkg and exp!\n')
    %     if ~isempty(bkg.k0)
    %         bkg.fit = ModelK(experiment.time{1},parameters0);
    %     else
    %         bkg.fit = ModelN(experiment.time{1},parameters0);
    %     end
end

%subtract mean
experiment.mean = experiment.rawmean-bkg.fit;

%find std
experiment.std = sqrt((experiment.rawstd).^2 + (bkg.fitStd).^2);

%remove negative data
experiment.mean(experiment.mean<0)=0;

%smooth data
if ~isempty(experiment.smoothstrength)
    experiment.mean = smoothdata(experiment.mean,"movmedian",experiment.smoothstrength);
end

%convert time
if bkg.minut ==1
    convert = 1/60;
elseif minut==2
    convert = 1/3600;
else
    convert = 1;
end

%plot
figure
scatter(convert.*(experiment.time{1}),experiment.rawmean,10,'k','filled');
hold on
shadedErrorBar(convert.*(experiment.time{1}),experiment.rawmean,experiment.rawstd,'lineProps','k');

scatter(convert.*(experiment.time{1}),bkg.fit,10,'r','filled');
shadedErrorBar(convert.*(experiment.time{1}),bkg.fit,bkg.fitStd,'lineProps','r');

scatter(convert.*(experiment.time{1}),experiment.mean,10,'g','filled');
plot(convert.*(experiment.time{1}),experiment.mean,'-','LineWidth',1,'Color','g');
%if ~isempty(experiment.std)
shadedErrorBar(convert.*(experiment.time{1}),experiment.mean,experiment.std,'lineProps','g');
%end
xlabel('Time')
ylabel('OD')
set(gca,'FontSize',20)
%set(gca,'YScale','log');
grid on
box on
axis tight

%import and store data
Data = struct();
Data.time = experiment.time{1};
Data.Xbkg = bkg.fit;
Data.Xbkgstd = bkg.std;
Data.XmeanRaw = experiment.rawmean;
Data.XmeanSmooth = experiment.mean;
Data.Xmean = experiment.mean;
Data.Xstd = experiment.std;

%bkg subtract every plot
for i=1:size(expR,2)
    Data.XRawNoBkg(:,i) = expR(:,i)-bkg.fit;
end

end