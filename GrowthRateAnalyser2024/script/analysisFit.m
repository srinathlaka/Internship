function analysisFit(inputs)

%% data files
addpath(genpath(inputs.folderData)) %%%%%%%%%%%%%%%%%%%%%%%%%%% folder where files are stored

mkdir(strcat(inputs.folderData,'/',num2str(inputs.expN)));
inputs.folderDataN = strcat(inputs.folderData,'/',num2str(inputs.expN));

%% number of experiment for reference
time_unit = 0; %1 minutes, 0 seconds, 2 hours

%% number of the dataset or experiment (single curve)

if ~isfile(strcat(inputs.folderDataN,'/','bkg.mat'))

    % parameters background for each replica
    bkg = struct();

    %want to do the background subtraction? %%%%%%%%%%%%%%%%%%%%%%%%%%%
    bkg.bkg_subract = 1; % 1 yes, 0 no

    if bkg.bkg_subract == 1  %bkg_subract ==1

        % filenames
        bkg.filenames = {strcat(inputs.folderData,'/',inputs.fileDataBkg)}; %%%%%%%%%%%%%%%%%%%%%%%%%%% %%CHANGE {'dataTest/test1.xlsx';'dataTest/test2.xlsx'};

        % wells for background (wells going from 1 to 96)
        bkg.wells = inputs.bkgWells; %%%%%%%%%%%%%%%%%%%%%%%%%%% %%CHANGE {[14,15,26,27];[3,4]}

        %parameters
        bkg.tin = {[]}; %initial time, [] for initial time {[];[]};
        bkg.tfin = {[]}; %final time, [] for maximal possible final time {[];[]};

        % create or load the background
        bkg.bkgAnalysis=1; %0 load, 1 create

        bkg.minut=time_unit; %1 minutes, 0 seconds, 2 hours

        % bkg computation

        if ~isfile(strcat(inputs.folderDataN,'/','bkg.mat')) %bkg.bkgAnalysis==1

            bkg.a0 = 1e-8;%factor overall;
            bkg.n = 2;
            bkg.k0 = []; %[] for polynomial model, negative for repression model
            bkg.b0 = []; %not necessary

            [bkg.bkgExp] = find_bkg(bkg); %%CHANGE output [bkg1] if have replicas to save it with a new name
            %close all

            save(strcat(inputs.folderDataN,'/','bkg.mat'),'bkg') %%CHANGE bkg.mat
        else
            load(strcat(inputs.folderDataN,'/','bkg.mat'),'bkg') %%CHANGE bkg.mat
        end

    else
        bkg.minut = time_unit; %1 minutes, 0 seconds, 2 hours
    end

else
    load(strcat(inputs.folderDataN,'/','bkg.mat'),'bkg') %%CHANGE bkg.mat
end

%% parameters experiment for each replica
if inputs.reanalysis==1
    experiment = struct();

    % filenames
    experiment.filenames = {strcat(inputs.folderData,'/',inputs.fileDataExp)}; %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % wells for background (wells going from 1 to 96)
    experiment.wells = inputs.expWells; %%%%%%%%%%%%%%%%%%%%%%%%%%%

    %parameters
    experiment.tin = inputs.tin; %{[]}; %initial time, [] for initial time
    experiment.tfin = inputs.tfin;%{[]}; %final time, [] for maximal possible final time

    %smooth data
    experiment.smoothstrength = [];

    %bkg subtraction and average
    averagecurves = inputs.averagecurves;%0;  % 1 don't average curves, plot and store also single bkg subtracted curves, 0 find the mean of curves %%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_excel = strcat(inputs.folderDataN,'/','bkg_corrected','.xlsx'); % [] not saved, a name to save it %%%%%%%%%%%%%%%%%%%%%%%%%%%
    [DataExp,experimentExp] = ExperimentSubtractBkg4(experiment,bkg.bkgExp,averagecurves,bkg.bkg_subract,time_unit,file_excel); %%CHANGE output [Data1,experiment1] and bkg1 if have replicas

    %% save each single replica with a name

    save(strcat(inputs.folderDataN,'/','Data.mat'),'DataExp') %% %%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE Data.mat
    save(strcat(inputs.folderDataN,'/','Exp.mat'),'experimentExp') %% %%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE experiment.mat
    save(strcat(inputs.folderDataN,'/','experiment.mat'),'experiment') %% %%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE experiment.mat

    % save('dataTest/Data4.mat','DataExp') %%CHANGE Data.mat
    % save('dataTest/experiment4.mat','experimentExp') %%CHANGE experiment.mat

    %% load all the biological replicas

    %1st biological replica
    D =load(strcat(inputs.folderDataN,'/','Data.mat'),'DataExp');
    %E = load(strcat(inputs.folderDataN,'/','Exp.mat'),'experimentExp');
    Data1 = D.DataExp; %%%%%%%%%%%%%%%%%%%%%%%%%%% change Data1
    %experiment1 = E.experimentExp; %%%%%%%%%%%%%%%%%%%%%%%%%%% change experiment1

    %2nd biological replica
    % D =load('dataTest/Data4.mat','DataExp');
    % E = load('dataTest/experiment4.mat','experimentExp');
    % Data2 = D.DataExp; %%%%%%%%%%%%%%%%%%%%%%%%%%% change Data2
    % experiment2 = E.experimentExp; %%%%%%%%%%%%%%%%%%%%%%%%%%% change experiment2

    % %3nd biological replica
    % D =load('dataTest/Data6.mat','DataExp');
    % E = load('dataTest/experiment6.mat','experimentExp');
    % Data3 = D.DataExp; %%%%%%%%%%%%%%%%%%%%%%%%%%% change Data2
    % experiment3 = E.experimentExp; %%%%%%%%%%%%%%%%%%%%%%%%%%% change experiment2

    %add more biological replicas

    %% save the biological replica to average them

    %save it in a structure %%%%%%%%%%%%%%%%%%%%%%%%%%%
    DataReplica.t{1} = Data1.time; %time
    DataReplica.r{1} = Data1.XmeanSmooth; %mean OD
    DataReplica.s{1} = Data1.Xstd; %OD std
    %...{2} etc for each replica

    %average over replicas
    DataR = averageNsets2(DataReplica,time_unit);

    %restore experiments time
    DataR.tin{1} = experimentExp.tin{1};
    DataR.tfin{1} = experimentExp.tfin{1};
    DataR.expN = inputs.expN;
    DataR.time_unit = time_unit;

    DataR.rb{1} = Data1.XRawNoBkg; %single OD bkg subtracted
    DataR.sb{1} = Data1.XRawNoBkgStd; %single OD bkg subtracted std

    %% save abalysis to file and to excel file the mean and std of biological replicas

    %% convert time

    %convert time and work with the new time
    if DataR.time_unit ==1
        Data.convert = 1/60;
    elseif DataR.time_unit==2
        Data.convert = 1/3600;
    else
        Data.convert = 1;
    end
    for i=1:size(DataR.time,2)
        DataR.time = Data.convert.*(DataR.time);
    end
    DataR.convert = Data.convert;

    save(strcat(inputs.folderDataN,'/','Replica.mat'),'DataR') %%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_excel = strcat(inputs.folderDataN,'/','Replica.xlsx'); % [] not saving %%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~isempty(file_excel)
        A = [DataR.time,DataR.XmeanSmooth,DataR.Xstd];
        writematrix(A,file_excel,'Sheet',1)
    end

else

    %load(strcat(inputs.folderDataN,'/',num2str(inputs.expN),'Data.mat'),'DataExp') %% %%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE Data.mat
    %load(strcat(inputs.folderDataN,'/',num2str(inputs.expN),'Exp.mat'),'experimentExp') %% %%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE experiment.mat
    %load(strcat(inputs.folderDataN,'/',num2str(inputs.expN),'experiment.mat'),'experiment') %% %%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE experiment.mat
    load(strcat(inputs.folderDataN,'/','Replica.mat'),'DataR')

end

if inputs.averagecurves == 0
    inputs.fitYN=0;
end

if inputs.fitYN==1
    %% fit

    load(strcat(inputs.folderDataN,'/','Replica.mat'),'DataR'); %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % data analysis and fit

    %cut time
    if isempty(inputs.tinFit{1})
        DataR.tin{1} = 1;
    else
        DataR.tin{1} = inputs.tinFit{1};
    end
    if isempty(inputs.tfinFit{1})
        DataR.tfin{1} = size(DataR.time,1);
    else
        DataR.tfin{1} = inputs.tfinFit{1};
    end

    %max OD
    [maxOD,index] = max(DataR.XmeanSmooth);
    maxODstd = DataR.XmeanSmooth(index);
    maxODt = DataR.time(index);
    
    %time when you cut the exp
    DataR.XmeanSmooth=DataR.XmeanSmooth(DataR.tin{1}:DataR.tfin{1},:);
    DataR.Xstd=DataR.Xstd(DataR.tin{1}:DataR.tfin{1},:);
    DataR.time = DataR.time(DataR.tin{1}:DataR.tfin{1},:)-DataR.time(DataR.tin{1},:);
    DataR.tin{1} = 1; %time when you cut the exp
    DataR.tfin{1} = size(DataR.time,1); %time when you cut the exp

    % parameters0 = [1 klag,2 tlag*,3 q,4 mu,5 tswitch*,6 kswitch,7 ks--,8 t--,9 k--,10 tdeath*,11 kdeath,12 m, 13 x0*, 14 k*, 15 k2*, 16 k3*]; time in cycles
    parameters0 = [NaN,NaN,1e-5,1e-3,NaN,2e-4,NaN,NaN,NaN,NaN,-1e-3,inputs.modelN,...
        NaN,NaN,NaN,NaN]; %%%%%%%%%%%%%%%%%%%%%%%%%%% model number entry 12

    parametersFit = struct();

    parametersFit.Chistd=1; %use std as weight in fit
    parametersFit.nbootstrap = []; %[] empty for no bootstrap, number for n of bootstraps %boostrap to find error on fit parameters
    parametersFit.confidenceprediction = 0; %0 95% confidence interval of fit function, 1 95% of finding new data in the interval

    Tdata = DataR.XmeanSmooth;
    parameters0(13) = min(Tdata(Tdata>0)); %x0
    if isnan(parameters0(14))
        parameters0(14)= max(Tdata); %k
    end

    parametersFit.alpha = 0.32; %CI of data, 0.05 for 95% 2 std, 0.32 68% for 1 std

    m = parameters0(12);
    numExp = 1;
    parametersFit.m = m;
    if m==1
        [Data,parametersFit] = fitESED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp+saturation - exp - exp death
    elseif m==2
        [Data,parametersFit] = fitLESED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %lag+exp+saturation - exp - exp death
    elseif m==3
        [Data,parametersFit] = fitLLESED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %linear lag - exp+saturation - exp - exp death
    elseif m==4
        [Data,parametersFit] = fitLLES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %linear lag - exp+saturation
    elseif m==5
        [Data,parametersFit] = fitLLLES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %linear lag - lag+exp+saturation
    elseif m==6
        [Data,parametersFit] = fitLLLE(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit);  %linear lag - lag+exp
    elseif m==7
        [Data,parametersFit] = fitEED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp - exp - exp death
    elseif m==8
        [Data,parametersFit] = fitESESD(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp+saturation - exp+saturation - exp death
    elseif m==9
        [Data,parametersFit] = fitESESED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp+saturation - exp+saturation - exp - exp death
    elseif m==10
        [Data,parametersFit] = fitEEED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp - exp - exp - exp death
    elseif m==11
        [Data,parametersFit] = fitES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp+saturation
    elseif m==12
        [Data,parametersFit] = fitLinear(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit);  %linear
    elseif m==13
        [Data,parametersFit] = fitLEED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %lag+exp - exp - exp death
    elseif m==14
        [Data,parametersFit] = fitLES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %lag+exp+saturation
    elseif m==15
        [Data,parametersFit] = fitESESES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp+saturation - exp+saturation - exp+saturation
    elseif m==16
        [Data,parametersFit] = fitESESEES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp+saturation - exp+saturation - exp - exp+saturation
    elseif m==17
        [Data,parametersFit] = fitLEES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %linear - exp - exp+saturation
    elseif m==18
        [Data,parametersFit] = fitLiEED(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %linear - exp - exp - death
    elseif m==19
        [Data,parametersFit] = fitLESE(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %lag+exp+saturation - exp
    elseif m==20
        [Data,parametersFit] = fitLESES(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %lag+exp+saturation - exp+saturation
    elseif m==21
        [Data,parametersFit] = fitLE(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %linear - exp
    elseif m==22
        [Data,parametersFit] = fitEXP(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %exp
    elseif m==23
        [Data,parametersFit] = fitLagExp(DataR,DataR.tin{1},DataR.tfin{1},parameters0,numExp,parametersFit); %lag+exp
    end

    %time is sotred as decided by the user (sec, min,h) and also in seconds in another vector
    %Data.convert = convert;
    convert=1/DataR.convert;
    Data.time_sec = convert.*(Data.time);

    %% store max OD
    parametersFit.p{1}(end+1) = maxOD;
    parametersFit.p{1}(end+1) = maxODstd;
    parametersFit.p{1}(end+1) = maxODt;

    %% save analysis

    Data.inputs = inputs;
    save(strcat(inputs.folderDataN,'/','DataF.mat'),'Data') %%CHANGE Data.mat %%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(strcat(inputs.folderDataN,'/','experiment.mat'),'experiment')
    save(strcat(inputs.folderDataN,'/','ExpF.mat'),'experiment') %%CHANGE experiment.mat %%%%%%%%%%%%%%%%%%%%%%%%%%%
    save(strcat(inputs.folderDataN,'/','Fit.mat'),'parametersFit') %%CHANGE parametersFit.mat %%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% save to excel file

    file_excel = strcat(inputs.folderDataN,'/','Fit.xlsx'); % [] not saving %%%%%%%%%%%%%%%%%%%%%%%%%%%
    convert_back_to_sec = 1; % 1 convert back to sec the time, 0 leave it as it is

    if convert_back_to_sec ==1
        convert=1/Data.convert;
    else
        convert=1;
    end

    if ~isempty(file_excel)

        A = [convert.*(Data.time),Data.XmeanSmooth];
        writematrix(A,file_excel,'Sheet',1) %mean
        A = [convert.*(Data.time),Data.Xstd];
        writematrix(A,file_excel,'Sheet',2) %std

        A = [convert.*(Data.time),Data.Xfit];
        writematrix(A,file_excel,'Sheet',3) %fit
        A = [convert.*(Data.time),Data.XfitStd];
        writematrix(A,file_excel,'Sheet',4) %std fit
    end


    %% load if necessary

    %load('dataTest/DataEXPtest1.mat','Data') %%CHANGE Data.mat
    %load('dataTest/experimentEXPtest1.mat','experiment') %%CHANGE experiment.mat
    %load('dataTest/parametersFitEXPtest1.mat','parametersFit') %%CHANGE parametersFit.mat

    %% end for a single dataset

end
end