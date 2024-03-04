function chisquareData = fitModelDrug(blackboxmodel,time,parametersD,Data,logplot,parameters)

%expected data from function
Xexpected = blackboxmodel(time,parametersD,parameters);
Xobserved = Data.X;

%chi square
% Xobserved(Xexpected ==0)=[];
% time(Xexpected ==0)=[];
% Xexpected(Xexpected ==0)=[];
chisquareData = sum( ((Xobserved-Xexpected).^2));
%chisquareData = sum( ((Xobserved-Xexpected).^2)./Xexpected.^2);
%chisquareData = sum( ((Xobserved-Xexpected).^2)./Xstd.^2);

%plot
figure(1001)
plot(time,Xexpected,'-r','LineWidth',1.5);
hold on
grid on
scatter(time,Xobserved,10,'k','filled');
if logplot==1
    set(gca,'YScale','log');
end
axis tight
drawnow
hold off

end