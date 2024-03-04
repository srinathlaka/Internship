function [Data] = SubstractBkg(filename,Databkg,wells,smoothstrength,minut)

%import excel file data
T = xlsread(filename);
time = T(:,1);

%convert time
if minut ==1
    time = time./60;
elseif minut==2
    time = time./3600;
end

X = T(:,wells+1);

%mean and std
if size(X,2)>1
    [XmeanRaw,Xstd] = MeanAndPlot(time,X);
else
    XmeanRaw=X;
    Xstd = [];
end

%subtract
Xmean = XmeanRaw-Databkg;

%remove negative data
Xmean(Xmean<0)=0;

if ~isempty(smoothstrength)
%smooth data
    XmeanSmooth = smoothdata(Xmean,"movmedian",smoothstrength);
else
    XmeanSmooth = Xmean;
end
%%
%plot
figure
scatter(time,XmeanRaw,10,'k','filled');
hold on
scatter(time,Databkg,10,'r','filled');
scatter(time,Xmean,10,'g','filled');
plot(time,Xmean,'-','LineWidth',2,'Color','r');
plot(time,XmeanSmooth,'-','LineWidth',2,'Color','b');
errorbar(time,Xmean,Xstd);
xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
%set(gca,'YScale','log');
grid on
box on
axis tight

%import and store data
Data = struct();
Data.time = time;
Data.Xbkg = Databkg;
Data.XmeanRaw = XmeanRaw;
Data.XmeanSmooth = XmeanSmooth;
Data.Xmean = Xmean;
Data.Xstd = Xstd;

end