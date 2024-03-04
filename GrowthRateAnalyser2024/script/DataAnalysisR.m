function [Data,parametersFit] = DataAnalysisR(filename1,tin,tfin,minut,WellsPlate1,WellsPlate2,parameters0,bkgAnalysis,d)

if bkgAnalysis==1

    %% find all the backgrounds
    Data_bkg = struct();
    parameters_bkg = struct();
    nshift=1;

    WellsPlate_bkg = [14,15,22,23,...
        14+12,15+12,22+12,23+12,...
        14+2*12,15+2*12,22+2*12,23+2*12,...
        14+3*12,15+3*12,22+3*12,23+3*12,...
        14+4*12,15+4*12,22+4*12,23+4*12,...
        14+5*12,15+5*12,22+5*12,23+5*12];
    a0 = 1e-6;
    k0 = [];
    n = 1;
    [Data_bkg.p{1},parameters_bkg.p{1}] = finerBaselineFlexyShift(filename1,tin,tfin,WellsPlate_bkg,minut,a0,k0,n,nshift);

    %% subtract the background then average the biological replica
    for i=1:6
        WellsPlate_1 = WellsPlate1+(i-1);
        WellsPlate_2 = WellsPlate2+(i-1);
        [Data1.p{i}] = SubstractBackground2(filename1,Data_bkg.p{1}.Xmean,WellsPlate_1,[],1,tin,tfin);
        [Data2.p{i}] = SubstractBackground2(filename1,Data_bkg.p{1}.Xmean,WellsPlate_2,[],1,tin,tfin);
        % average data and std
        %Data.p{i} = average2sets(Data1,Data2);
        close all
    end

    %%
    save('dataRebecca/Data1.mat','Data1')
    save('dataRebecca/Data2.mat','Data2')

else
    load('dataRebecca/Data1.mat','Data1')
    load('dataRebecca/Data2.mat','Data2')
end

%% data analysis and fit
if d==1
    parametersFit = struct();
    for i=1:6
        Tdata = Data1.p{i}.XmeanSmooth;
        md = min(Tdata(Tdata>0));
        if isempty(md)
            parameters0.p{i}(13)=0;
        else
            parameters0.p{i}(13) = min(Tdata(Tdata>0)); %x0
        end
        parameters0.p{i}(14)= max(Tdata); %k

        if parameters0.p{i}(13) == parameters0.p{i}(14)
            Data1.p{i}.Xfit = Data1.p{i}.XmeanSmooth;
            parametersFit.p{i} = 0.*parameters0.p{i};
        else
            m = parameters0.p{i}(12);
            i
            if m==1
                [Data1.p{i},parametersFit] = fitESED(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp - exp death
            elseif m==2
                [Data1.p{i},parametersFit] = fitLESED(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %lag+exp+saturation - exp - exp death
            elseif m==3
                [Data1.p{i},parametersFit] = fitLLESED(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - exp+saturation - exp - exp death
            elseif m==4
                [Data1.p{i},parametersFit] = fitLLES(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - exp+saturation
            elseif m==5
                [Data1.p{i},parametersFit] = fitLLLES(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - lag+exp+saturation
            elseif m==6
                [Data1.p{i},parametersFit] = fitLLLE(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit);  %linear lag - lag+exp
            elseif m==7
                [Data1.p{i},parametersFit] = fitEED(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp - exp - exp death
            elseif m==8
                [Data1.p{i},parametersFit] = fitESESD(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp+saturation - exp death
            elseif m==9
                [Data1.p{i},parametersFit] = fitESESED(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp+saturation - exp - exp death
            elseif m==10
                [Data1.p{i},parametersFit] = fitEEED(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp - exp - exp - exp death
            elseif m==11
                [Data1.p{i},parametersFit] = fitES(Data1.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation
            end
        end
    end

    Data = Data1;

elseif d==2

    parametersFit = struct();
    for i=1:6
        Tdata = Data2.p{i}.XmeanSmooth;
        md = min(Tdata(Tdata>0));
        if isempty(md)
            parameters0.p{i}(13)=0;
        else
            parameters0.p{i}(13) = min(Tdata(Tdata>0)); %x0
        end
        parameters0.p{i}(14)= max(Tdata); %k

        if parameters0.p{i}(13) == parameters0.p{i}(14)
            Data2.p{i}.Xfit = Data2.p{i}.XmeanSmooth;
            parametersFit.p{i} = 0.*parameters0.p{i};
        else
            m = parameters0.p{i}(12);
            i
            if m==1
                [Data2.p{i},parametersFit] = fitESED(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp - exp death
            elseif m==2
                [Data2.p{i},parametersFit] = fitLESED(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %lag+exp+saturation - exp - exp death
            elseif m==3
                [Data2.p{i},parametersFit] = fitLLESED(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - exp+saturation - exp - exp death
            elseif m==4
                [Data2.p{i},parametersFit] = fitLLES(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - exp+saturation
            elseif m==5
                [Data2.p{i},parametersFit] = fitLLLES(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %linear lag - lag+exp+saturation
            elseif m==6
                [Data2.p{i},parametersFit] = fitLLLE(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit);  %linear lag - lag+exp
            elseif m==7
                [Data2.p{i},parametersFit] = fitEED(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp - exp - exp death
            elseif m==8
                [Data2.p{i},parametersFit] = fitESESD(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp+saturation - exp death
            elseif m==9
                [Data2.p{i},parametersFit] = fitESESED(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation - exp+saturation - exp - exp death
            elseif m==10
                [Data2.p{i},parametersFit] = fitEEED(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp - exp - exp - exp death
            elseif m==11
                [Data2.p{i},parametersFit] = fitES(Data2.p{i},tin,tfin,parameters0.p{i},i,parametersFit); %exp+saturation
            end
        end
    end

    Data = Data2;

end


end