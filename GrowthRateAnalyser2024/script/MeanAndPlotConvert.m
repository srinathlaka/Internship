function [Xmean,Xstd] = MeanAndPlotConvert(time,X,time_unit)

%mean and std
Xmean = mean(X,2);
Xstd = std(X,1,2);

%remove zero std
nzm = min(Xstd(Xstd>0));
Xstd(Xstd<=0)=nzm;

%convert time
if time_unit ==1
    convert = 1/60;
elseif time_unit==2
    convert = 1/3600;
else
    convert = 1;
end

%plot
figure
shadedErrorBar(convert.*time,Xmean,Xstd,'lineProps','k');
hold on
scatter(convert.*time,Xmean,10,'k','filled');
set(gca,'YScale','log');
if time_unit==1
    xlabel('Time [min]')
elseif time_unit==2
    xlabel('Time [hours]')
else
    xlabel('Time [sec]')
end
ylabel('OD')
title('Mean and standard devition')
grid on
box on
axis tight

end