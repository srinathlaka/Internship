function [Data,parametersFit] = DataAnalysisI(filename1,filename2,tin,tfin,minut,WellsPlate1,WellsPlate2,parameters0,bkgAnalysis,drugscurves)

if bkgAnalysis==1
    %% find all the backgrounds
    Data_bkg_1 = struct();
    parameters_bkg_1 = struct();
    nshift=1;
    [Data_bkg_1,parameters_bkg_1] = bkgI(Data_bkg_1,parameters_bkg_1,filename1,tin,tfin,minut,nshift);
    close all

    Data_bkg_2 = struct();
    parameters_bkg_2 = struct();
    nshift=10;
    [Data_bkg_2,parameters_bkg_2] = bkgI(Data_bkg_2,parameters_bkg_2,filename2,tin,tfin,minut,nshift);
    close all

    %% subtract the background then average the biological replica

    for i=1:6
        WellsPlate_1 = WellsPlate1+(i-1)*12;
        WellsPlate_2 = WellsPlate2+(i-1)*12;
        [Data1] = SubstractBackground2(filename1,Data_bkg_1.p{i}.Xmean,WellsPlate_1,[],1,tin,tfin);
        [Data2] = SubstractBackground2(filename2,Data_bkg_2.p{i}.Xmean,WellsPlate_2,[],1,tin,tfin);
        % average data and std
        Data.p{i} = average2sets(Data1,Data2);
        close all
    end

    %%
    save('dataIse/Data.mat','Data')
else
    load('dataIse/Data.mat','Data')
end

%% data analysis and fit
parametersFit = struct();
for i=drugscurves
    Tdata = Data.p{i}.XmeanSmooth;
    md = min(Tdata(Tdata>0));
    if isempty(md)
        parameters0.p{i}(13)=0;
    else
        parameters0.p{i}(13) = min(Tdata(Tdata>0)); %x0
    end
    parameters0.p{i}(14)= max(Tdata); %k

    if parameters0.p{i}(13) == parameters0.p{i}(14)
        Data.p{i}.Xfit = Data.p{i}.XmeanSmooth;
        parametersFit.p{i} = 0.*parameters0.p{i};
    else
        m = parameters0.p{i}(12);
        i
        if m==1
            [Data.p{i},parametersFit] = fitESED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp - exp death
        elseif m==2
            [Data.p{i},parametersFit] = fitLESED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %lag+exp+saturation - exp - exp death
        elseif m==3
            [Data.p{i},parametersFit] = fitLLESED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - exp+saturation - exp - exp death
        elseif m==4
            [Data.p{i},parametersFit] = fitLLES(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - exp+saturation
        elseif m==5
            [Data.p{i},parametersFit] = fitLLLES(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - lag+exp+saturation
        elseif m==6
            [Data.p{i},parametersFit] = fitLLLE(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit);  %linear lag - lag+exp
        elseif m==7
            [Data.p{i},parametersFit] = fitEED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp - exp - exp death
        elseif m==8
            [Data.p{i},parametersFit] = fitESESD(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp+saturation - exp death
        elseif m==9
            [Data.p{i},parametersFit] = fitESESED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp+saturation - exp - exp death
        elseif m==10
            [Data.p{i},parametersFit] = fitEEED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp - exp - exp - exp death
        elseif m==11
            [Data.p{i},parametersFit] = fitES(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation
        elseif m==12
            [Data.p{i},parametersFit] = fitLinear(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit);  %linear
        elseif m==13
            [Data.p{i},parametersFit]  = fitLEED(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %lag+exp - exp - exp death
        elseif m==14
            [Data.p{i},parametersFit]  = fitLES(Data.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %lag+exp+saturation

        end
    end
end


end