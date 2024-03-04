function [Data] = ModelDrugX0BKGsubtractionOnly(filename,Data0,parameters0)


%import excel file data
%filename = 'data\rif0.xlsx';
T = xlsread(filename);
time = T(:,1);
X = T(:,2:end);

%compute beaseline
X0mean = Model0(time,parameters0);
Data0.X = X0mean;
X0mean = Data0.X;

%mean and std
if size(X,2)>1
    [Xmean,Xstd] = MeanAndPlot(time,X);
else
    Xmean=X;
    Xstd = [];
    
    %plot
    figure
    scatter(time,Xmean,20,'filled');
    set(gca,'YScale','log');
    xlabel('Time [min]')
    ylabel('OD')
    grid on
    box on
    axis tight
end

%%
%plot
figure
scatter(time,Xmean,10,'k','filled');
hold on
scatter(time,X0mean,10,'r','filled');
scatter(time,Xmean-X0mean,10,'g','filled');
xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
%set(gca,'YScale','log');
grid on
box on
axis tight

%subtract empty wells from data
Xmean = Xmean-X0mean;

%%
%remove negative data
Xmean(Xmean<0)=0;

%import and store data
Data = struct();
Data.time = time;
Data.X = Xmean;
Data.Xstd = Xstd;


end