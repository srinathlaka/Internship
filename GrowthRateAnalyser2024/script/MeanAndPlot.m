function [Xmean,Xstd] = MeanAndPlot(time,X)

%mean and std
Xmean = mean(X,2);
Xstd = std(X,1,2);

%remove zero std
nzm = min(Xstd(Xstd>0));
Xstd(Xstd<=0)=nzm;

%plot
figure
shadedErrorBar(time,Xmean,Xstd,'lineProps','k');
hold on
scatter(time,Xmean,10,'k','filled');
set(gca,'YScale','log');
xlabel('Time [sec]')
ylabel('OD')
title('Mean and standard devition')
grid on
box on
axis tight

end