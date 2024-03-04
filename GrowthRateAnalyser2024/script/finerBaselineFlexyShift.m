function [Data0,parameters0] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift)

%control empty wells
T0 = xlsread(filename0);
time = T0(tin:tfin,1);
if tin>1
    time = time-time(1);
    timet = T0(:,1);
    X0t = T0(:,WellsPlate+1);
end

%convert to min
if minut ==1
    time = time./60;
    if tin>1
        timet = timet./60;
    end
elseif minut==2
    time = time./3600;
    if tin>1
        timet = timet./3600;
    end
else
    timet = time;
end

X0 = T0(tin:tfin,WellsPlate+1);

%mean and std
if size(X0,2)>1
    [X0mean,X0std] = MeanAndPlot(time,X0);
    if tin>1
        [X0meant,X0stdt] = MeanAndPlot(timet,X0t);
    end
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
Data0.Xmean = X0mean;
Data0.X = X0mean;
Data0.Xstd = X0std;

%% finer subtraction

parameters0 = struct();
parameters0.a0 = a0;
parameters0.n = n;
parameters0.k0 = k0;
parameters0.b0 = X0mean(nshift);

if ~isempty(k0)

    blackboxmodel0 = @ModelK; %non linear
    P00 = [parameters0.a0,parameters0.k0];

    options = optimset('Display','iter','PlotFcns',@optimplotfval);
    lb = [];
    ub = [];

    [fittedParameters0,~] = fminsearchbnd(@(P) minimizeChiSquare0(P,blackboxmodel0,time,parameters0,Data0),P00,lb,ub,options);
    fprintf('a0 = %f, k0 = %f \n',fittedParameters0(1),fittedParameters0(2));

    parameters0.a0 = fittedParameters0(1);
    parameters0.b0 = X0mean(1);
    parameters0.k0 = fittedParameters0(2);
    Xbest = ModelK(time,parameters0);
    Data0.Xbest = Xbest;


else

    blackboxmodel0 = @ModelN;
    P00 = [parameters0.a0];

    options = optimset('Display','iter','PlotFcns',@optimplotfval);
    lb = [];
    ub = [];

    [fittedParameters0,~] = fminsearchbnd(@(P) minimizeChiSquareL(P,blackboxmodel0,time,parameters0,Data0),P00,lb,ub,options);
    fprintf('a0 = %f, b0 = %f, n = %f \n',fittedParameters0(1),parameters0.b0,parameters0.n);

    parameters0.a0 = fittedParameters0(1);
    parameters0.b0 = X0mean(1);
    parameters0.k0 = k0;
    Xbest = ModelN(time,parameters0);
    Data0.Xmodel = Xbest;


end


%plot
figure
plot(time,Xbest,'-','LineWidth',2,'Color','r');
hold on
errorbar(time,X0mean,X0std);
scatter(time,X0mean,10,'k','filled');
xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

if tin>1
    if ~isempty(k0)
        parameters0.b0 = X0mean(1) - k0.*((time(1))./(time(1)+parameters0.a0));
    else
        parameters0.b0 = X0mean(1) - time(1).*parameters0.a0;
    end
    if minut ==1
        Data0.time  = Data0.time + T0(tin,1)./60;
    elseif minut==2
        Data0.time  = Data0.time + T0(tin,1)./3600;
    end
    Data0.timeAll = timet;
    Data0.Xmean = X0meant;
    Data0.X = X0meant;
    Data0.Xstd = X0stdt;
end



end