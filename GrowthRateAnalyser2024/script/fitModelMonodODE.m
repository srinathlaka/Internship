function chisquareData = fitModelMonodODE(blackboxmodel,time,Data,logplot,parameters)

Xobserved = Data.X;

s0 = parameters.x0;
%solve ODE
odeOptions = odeset('RelTol',1e-6,'NonNegative',[1:size((s0),2)]);
[~, XexpectedT] = ode45(@(t, x) blackboxmodel(t,x,parameters),time,s0,odeOptions);
Xexpected = XexpectedT(:,1);

%chi square
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