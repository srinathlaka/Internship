function datasetsAnalysis(inputs_folderData,exps_to_load,name_condition,convert_unit)

if convert_unit ==1
    convert = 1/60;
    labelX = ['Time',' ','[min]'];
elseif convert_unit ==2
    convert = 1/3600;
    labelX = ['Time',' ','[h]'];
else
    convert = 1;
    labelX = ['Time',' ','[sec]'];
end

DataF = struct();
parametersF = struct();
sizeraw = 0;
for i=1:size(exps_to_load,2)

    %load all the datasets to plot together
    num=exps_to_load(i);
    load(strcat(inputs_folderData,'/',num2str(num),'/DataF.mat'),'Data')
    load(strcat(inputs_folderData,'/',num2str(num),'/Fit.mat'),'parametersFit')
    load(strcat(inputs_folderData,'/',num2str(num),'/Replica.mat'),'DataR')
    DataF.p{i} = Data;
    DataF.r{i} = DataR;
    parametersF.p{i} = parametersFit.p{1};
    parametersF.s{i} = parametersFit.s{1};
    sizeraw = sizeraw + size(Data.rb{1},2);
end

% color vector
nexp = size(DataF.p,2);
vectorcolor = distinguishable_colors(nexp);

%% plot summary all

figure
for i=1:size(DataF.p,2)
    hold on
    scatter(convert.*DataF.p{i}.time,DataF.p{i}.XmeanSmooth,5,vectorcolor(i,:),'filled');
    if ~isempty(DataF.p{i}.XfitStd)
        s3=shadedErrorBar(convert.*DataF.p{i}.time,DataF.p{i}.Xfit,DataF.p{i}.XfitStd,'lineProps',{'Color',vectorcolor(i,:)});
    end
end
xlabel(labelX)
ylabel('OD bkg subtracted fit')
set(gca,'FontSize',20)
grid on
box on
axis tight


%% plot summary raw bkg subtracted mean

figure
for i=1:size(DataF.p,2)
    hold on
    s2=shadedErrorBar(convert.*DataF.p{i}.time,DataF.p{i}.XmeanSmooth,DataF.p{i}.Xstd,'lineProps',{'color',vectorcolor(i,:)});
end
xlabel(labelX)
ylabel('OD bkg subtracted')
set(gca,'FontSize',20)
grid on
box on
axis tight
hold off

%% raw all

figure
for i=1:size(DataF.p,2)
    hold on
    if ~isempty(DataF.r{i}.Xstd)
        shadedErrorBar(convert.*DataF.r{i}.time,DataF.r{i}.XmeanSmooth,DataF.r{i}.Xstd,'lineProps',{'Color',vectorcolor(i,:)});
    else
        scatter(convert.*DataF.r{i}.time,DataF.r{i}.XmeanSmooth,5,vectorcolor(i,:),'filled');
    end
end
xlabel(labelX)
ylabel('OD bkg subtracted')
set(gca,'FontSize',20)
grid on
box on
axis tight
hold off

%% all raw bkg subtracted
vectorcolor = distinguishable_colors(sizeraw);
k=1;
figure
for i=1:size(DataF.r,2)
    hold on
    for l=1:size(DataF.r{i}.sb{1},2)
        shadedErrorBar(convert.*DataF.r{i}.time,DataF.r{i}.rb{1}(:,l),DataF.r{i}.sb{1}(:,l),'lineProps',{'color',vectorcolor(k,:)});
        k=k+1;
    end
end
xlabel(labelX)
ylabel('OD bkg subtracted')
set(gca,'FontSize',20)
grid on
box on
axis tight
hold off

%% save datasets
name_condition = strcat(inputs_folderData,'/',name_condition);
mkdir(name_condition);
DataF.convert = convert;
DataF.convert_unit = convert_unit;
save(strcat(name_condition,'/Dataset.mat'),'DataF')
save(strcat(name_condition,'/parametersFtest.mat'),'parametersF')


end