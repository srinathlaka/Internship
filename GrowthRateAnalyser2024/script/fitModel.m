function chisquareData = fitModel(blackboxmodel,time,parameters,Data,logplot,ODE)

Xobserved = Data.X;

if ODE==0
    Xexpected = blackboxmodel(time,parameters);
else
    s0 = parameters.parData;
    %solve ODE
    odeOptions = odeset('RelTol',1e-6,'NonNegative',[1:size((s0),2)]);
    [~, Xexpected] = ode45(@(t, x) blackboxmodel(t,x,parametersD,parameters),time,s0,odeOptions);
end

%chi square
% Xobserved(Xexpected ==0)=[];
% time(Xexpected ==0)=[];
% Xexpected(Xexpected ==0)=[];

if parameters.Chistd == 0
    chisquareData = sum( ((Xobserved-Xexpected).^2));
elseif parameters.Chistd == 1
    if ~isempty(Data.Xstd)
        Xstd = Data.Xstd;
        %chisquareData = sum( ((Xobserved-Xexpected).^2)./Xexpected.^2);
        chisquareData = sum( ((Xobserved-Xexpected).^2)./Xstd.^2);
    else
        chisquareData = sum( ((Xobserved-Xexpected).^2));
    end
end

% %parameters
% %plot
% figure(1001)
% plot(time,Xexpected,'-r','LineWidth',1.5);
% hold on
% grid on
% scatter(time,Xobserved,10,'k','filled');
% if logplot==1
%     set(gca,'YScale','log');
% end
% axis tight
% drawnow
% hold off

end