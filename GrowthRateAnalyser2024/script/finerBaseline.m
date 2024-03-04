function [Data0,parameters0] = finerBaseline(filename0,a0,k0)

%control empty wells
% filename0 = 'data\raw0.xlsx';
T0 = xlsread(filename0);
time = T0(:,1);
X0 = T0(:,2:end);

%mean and std
if size(X0,2)>1
    [X0mean,X0std] = MeanAndPlot(time,X0);
else
    X0mean=X0;
    X0std = [];
end

%% finer subtraction

% a0 = 0.0091;%2*abs(min(X0mean));
% b0 = X0mean(1);
% k0 = 2.9;%max(time);
parameters0 = struct();
parameters0.a0 = a0;
%parameters0.b0 = b0;
parameters0.k0 = k0;
parameters0.b0 = X0mean(1);

blackboxmodel0 = @Model0;
options = optimset('Display','iter','PlotFcns',@optimplotfval);
P00 = [parameters0.a0,parameters0.k0];
%P00 = [parameters0.a0,parameters0.b0,parameters0.k0];
lb = [];
ub = [];
Data0 = struct();
Data0.time = time;
Data0.X = X0mean;
Data0.Xstd = X0std;
[fittedParameters0,~] = fminsearchbnd(@(P) minimizeChiSquare0(P,blackboxmodel0,time,parameters0,Data0),P00,lb,ub,options);
fprintf('a0 = %f, k0 = %f \n',fittedParameters0(1),fittedParameters0(2));
%fprintf('a0 = %f, b0 = %f, k0 = %f \n',fittedParameters0(1),fittedParameters0(2),fittedParameters0(3));

% parameters0.a0 = fittedParameters0(1);
% parameters0.b0 = fittedParameters0(2);
% parameters0.k0 = fittedParameters0(3);
parameters0.a0 = fittedParameters0(1);
parameters0.b0 = X0mean(1);
parameters0.k0 = fittedParameters0(2);
Xbest = Model0(time,parameters0);
Data0.Xbest = Xbest;

%plot
figure
plot(time,Xbest,'-','LineWidth',2,'Color','r');
hold on
scatter(time,X0mean,10,'k','filled');
xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight


end