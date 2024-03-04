function rescaleGR(inputs_folderData,name_condition,condition_ylabel,units_label,condition_media1,condition_media2,condition_value,convertf,convertp,units_labelf)

%% load

name_condition = strcat(inputs_folderData,'/',name_condition);
load(strcat(name_condition,'/Dataset.mat'),'DataF')
%load(strcat(name_condition,'/parametersFtest.mat'),'parametersF')

% color vector
nexp = size(DataF.r,2);
vectorcolor = distinguishable_colors(nexp);

%% convert
%dbl time at drug 0
load(strcat(name_condition,'/',condition_ylabel,'.mat'),'A_u')
convert = A_u(1,2)./log(2);
convert_std = A_u(1,3)./log(2);

%% plot raw bkg subtracted

figure
for i=1:size(DataF.r,2)
    hold on
    errorbar(convert.*DataF.r{i}.time,DataF.r{i}.XmeanSmooth,DataF.r{i}.Xstd, 'color', vectorcolor(i,:));
    errorbar(convert.*DataF.r{i}.time,DataF.r{i}.XmeanSmooth,convert_std.*DataF.r{i}.time,'horizontal','color', vectorcolor(i,:));
    % s2=shadedErrorBar(convert.*DataF.r{i}.time,DataF.r{i}.XmeanSmooth,DataF.r{i}.Xstd,'lineProps',{'color',vectorcolor(i,:)});
end
xlabel('Time \mu_0 /ln(2)')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

%% save to file

%% 
file_excel = strcat(name_condition,'/','rescaledGR','.xlsx');

tGR = struct();
for i=1:size(DataF.r,2)
    tGR.values{i} = [convert.*DataF.r{i}.time,convert_std.*DataF.r{i}.time,DataF.r{i}.XmeanSmooth,DataF.r{i}.Xstd];
    T = array2table(tGR.values{i},'VariableNames', {'Time mu0 /ln(2)','Time mu0 /ln(2) std','OD','OD std'});
    writetable(T, file_excel, 'WriteVariableNames', true,'Sheet',i);
end

save(strcat(name_condition,'/','rescaledGR','.mat'),'tGR')

%% save to file table

file_excel = strcat(inputs_folderData,'/',condition_media2,'.xlsx');
replicate=[];
AB = [];
time = [];
OD = [];
OD_std = [];
GR0 = [];
GR0_std = [];
GR0ln2 = [];
GR0ln2_std = [];
for i=1:size(DataF.r,2)
    for l=1:size(DataF.r{i}.rb{1},2)
        ts = size(DataF.r{i}.rb{1},1);
        replicate = [replicate;l.*ones(ts,1)];
        AB = [AB;condition_value(i).*ones(ts,1)];
        time = [time;convertf.*DataF.r{i}.time];
        OD = [OD;DataF.r{i}.rb{1}(:,l)];
        OD_std = [OD_std;DataF.r{i}.sb{1}(:,l)];
        GR0 = [GR0;convertp.*A_u(1,2).*ones(ts,1)];
        GR0_std = [GR0_std;convertp.*A_u(1,3).*ones(ts,1)];
        GR0ln2 = [GR0ln2;(convertp.*A_u(1,2)./log(2)).*ones(ts,1)];
        GR0ln2_std = [GR0ln2_std;(convertp.*A_u(1,3)./log(2)).*ones(ts,1)];
    end
end

totalsize = size(replicate,1);
media = string(repelem(condition_media2,totalsize,1));
ph = condition_media1.*ones(totalsize,1);
rescaled = time.*GR0ln2;
rescaled_std = time.*GR0ln2_std;

T = table(ph,media,replicate,AB,time,OD,OD_std,GR0,GR0_std,GR0ln2,GR0ln2_std,rescaled,rescaled_std);
T = renamevars(T,["ph","media","replicate","AB","time","OD","OD_std","GR0","GR0_std","GR0ln2","GR0ln2_std","rescaled","rescaled_std"], ...
                 ["pH","Media","Replicate","AB conc [mug/mL]",strcat("Time ",units_labelf),"OD bkg subtr.","OD std",strcat("GR_0 ",units_label),strcat("GR_0 std ",units_label),strcat("GR_0/ln(2) ",units_label),strcat("GR_0/ln(2) std ",units_label),"Rescaled time","Rescaled time std"]);

writetable(T, file_excel, 'WriteVariableNames', true);



end




