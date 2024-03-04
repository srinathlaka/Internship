function chisquareData = fitModelDrugODE(blackboxmodel,time,parametersD,Data,logplot,parameters)

Xobserved = Data.X;

%expected data from function
%Xexpected = blackboxmodel(time,parametersD,parameters);
%solve expected model
%s0 = Xobserved(1);
s0 = parameters.x0;
%solve ODE
odeOptions = odeset('RelTol',1e-6,'NonNegative',[1:size((s0),2)]);
[~, Xexpected] = ode45(@(t, x) blackboxmodel(t,x,parametersD,parameters),time,s0,odeOptions);


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