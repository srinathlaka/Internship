function Data = averageNsets(DataReplica)

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

% color vector
nexp = size(DataReplica.r,2);
vectorcolor = distinguishable_colors(nexp);

figure
for i=1:size(DataReplica.r,2)
    hold on
    scatter(DataReplica.t{i},DataReplica.r{i},10,vectorcolor(i,:),'filled');
    if ~isempty(DataReplica.s{i})
        %errorbar(DataReplica.t{i},DataReplica.r{i},DataReplica.s{i},'Color',vectorcolor(i,:));
        shadedErrorBar(DataReplica.t{i},DataReplica.r{i},DataReplica.s{i},'lineProps',{'color',vectorcolor(i,:)});
    end
end
plot(Data.time,Data.XmeanSmooth,'-','LineWidth',1,'Color',[[0 0 0],0.4]);
shadedErrorBar(Data.time,Data.XmeanSmooth,Data.Xstd,'lineProps',{'color',[0 0 0]});
%errorbar(Data.time,Data.XmeanSmooth,Data.Xstd,'Color',[0 0 0]);
xlabel('Time')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight





end