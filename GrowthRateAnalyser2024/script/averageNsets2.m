function Data = averageNsets2(DataReplica,time_unit)

Data = struct();

if size(DataReplica.r,2)>1
    %time
    fintT = min(cellfun(@numel, DataReplica.t));
    Data.time = DataReplica.t{1}(1:fintT);

    %data
    DataT = zeros(fintT,size(DataReplica.r,2));
    DataS = zeros(fintT,size(DataReplica.s,2));
    for i=1:size(DataReplica.r,2)
        DataT(:,i) = DataReplica.r{i}(1:fintT);
        DataS(:,i) = DataReplica.s{i}(1:fintT);
    end

    %average
    Data.XmeanSmooth = mean(DataT,2);

    %std for independent datasets cov=0
    Data.Xstd = rssq(DataS,2)./size(DataReplica.r,2);

else
    Data.time = DataReplica.t{1};
    Data.XmeanSmooth = DataReplica.r{1};
    Data.Xstd = DataReplica.s{1};
end

%% plot

if size(DataReplica.r{1},2)==1

    % color vector
    nexp = size(DataReplica.r,2);
    vectorcolor = distinguishable_colors(nexp);

    %convert time
    if time_unit ==1
        convert = 1/60;
    elseif time_unit==2
        convert = 1/3600;
    else
        convert = 1;
    end

    figure
    for i=1:size(DataReplica.r,2)
        hold on
        scatter(convert.*(DataReplica.t{i}),DataReplica.r{i},10,vectorcolor(i,:),'filled');
        if ~isempty(DataReplica.s{i})
            %errorbar(DataReplica.t{i},DataReplica.r{i},DataReplica.s{i},'Color',vectorcolor(i,:));
            shadedErrorBar(convert.*(DataReplica.t{i}),DataReplica.r{i},DataReplica.s{i},'lineProps',{'color',vectorcolor(i,:)});
        end
    end
    plot(convert.*(Data.time),Data.XmeanSmooth,'-','LineWidth',1,'Color',[[0 0 0],0.4]);
    shadedErrorBar(convert.*(Data.time),Data.XmeanSmooth,Data.Xstd,'lineProps',{'color',[0 0 0]});
    %errorbar(Data.time,Data.XmeanSmooth,Data.Xstd,'Color',[0 0 0]);
    if time_unit==1
        xlabel('Time [min]')
    elseif time_unit==2
        xlabel('Time [hours]')
    else
        xlabel('Time [sec]')
    end
    %xlabel('Time [sec]')
    ylabel('OD')
    title('Biological replicas and mean')
    set(gca,'FontSize',20)
    grid on
    box on
    axis tight

    figure
    % plot(Data.time,Data.XmeanSmooth,'-','LineWidth',1,'Color',[[0 0 0],0.4]);
    % hold on
    shadedErrorBar(convert.*(Data.time),Data.XmeanSmooth,Data.Xstd,'lineProps',{'color',[0 0 0],'LineWidth',2});
    %errorbar(Data.time,Data.XmeanSmooth,Data.Xstd,'Color',[0 0 0]);
    if time_unit==1
        xlabel('Time [min]')
    elseif time_unit==2
        xlabel('Time [hours]')
    else
        xlabel('Time [sec]')
    end
    %xlabel('Time [sec]')
    ylabel('OD')
    title('Mean of biological replicas')
    set(gca,'FontSize',20)
    grid on
    box on
    axis tight

end


end