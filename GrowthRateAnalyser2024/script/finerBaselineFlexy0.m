function [Data0] = finerBaselineFlexy0(filename0,tin,tfin,initial,final,minut)

%control empty wells
T0 = xlsread(filename0);
time = T0(tin:tfin,1);
%convert to min
if minut ==1
    time = time./60;
elseif minut==2
    time = time./3600;
end

X0 = T0(tin:tfin,initial:final);

%mean and std
if size(X0,2)>1
    [X0mean,X0std] = MeanAndPlot(time,X0);
else
    X0mean=X0;
    X0std = [];
    
    %plot
    figure
    scatter(time,X0mean,20,'filled');
    set(gca,'YScale','log');
    xlabel('Time')
    ylabel('OD')
    grid on
    box on
    axis tight
    
end

Data0 = struct();
Data0.time = time;
Data0.X = X0mean;
Data0.Xstd = X0std;

% %% finer subtraction
% 
% parameters0 = struct();
% parameters0.a0 = a0;
% parameters0.k0 = k0;
% parameters0.b0 = X0mean(1);
% 
% blackboxmodel0 = @Model0;
% options = optimset('Display','iter','PlotFcns',@optimplotfval);
% P00 = [parameters0.a0,parameters0.k0];
% lb = [];
% ub = [];
% 
% [fittedParameters0,~] = fminsearchbnd(@(P) minimizeChiSquare0(P,blackboxmodel0,time,parameters0,Data0),P00,lb,ub,options);
% fprintf('a0 = %f, k0 = %f \n',fittedParameters0(1),fittedParameters0(2));
% 
% parameters0.a0 = fittedParameters0(1);
% parameters0.b0 = X0mean(1);
% parameters0.k0 = fittedParameters0(2);
% Xbest = Model0(time,parameters0);
% Data0.Xbest = Xbest;
% 
% %plot
% figure
% plot(time,Xbest,'-','LineWidth',2,'Color','r');
% hold on
% scatter(time,X0mean,10,'k','filled');
% xlabel('Time [min]')
% ylabel('OD')
% set(gca,'FontSize',20)
% grid on
% box on
% axis tight



end