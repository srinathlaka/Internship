function summaryIse(parametersF)

nDrug = 6;
% parameters0.p{1} = [1 klag,2 tlag*,3 q0,4 mu0,5 tswitch*,6 kswitch,7 --,8 --,9 --,10 tdeath*,11 kdeath,12 m ] ////(**13 x0,**14 k);

%% growth rate - entry 4 of parametersF
k=1;
tableP = zeros(nDrug*size(parametersF.s,2),1);
for i=1:size(parametersF.s,2)
    for j=1:nDrug
        tableP(k) = parametersF.s{i}.p{j}(4);
        k=k+1;
    end
end

dataPlot = table();
% Categorical variable
dataPlot.condition = cell(k-1,1);
dataPlot.condition(1:k-1) = {'Mu'};
dataPlot.condition = categorical(dataPlot.condition);

% Numerical variable
dataPlot.value = zeros(k-1,1);
dataPlot.value = tableP;

%color for strains
nstrains = size(parametersF.s,2);
vectorcolorT = distinguishable_colors(nstrains);
vectorcolor = zeros(k-1,3);
l=1;
for i=1:size(parametersF.s,2)
    for j=1:nDrug
        vectorcolor(l,:) = vectorcolorT(i,:);
        l=l+1;
    end
end

%stringMarker for drugs
%nstrains = size(parametersF.s,2);
stringT = ['o','d','s','p','h','^']; %,'v'
%stringM = string(k-1,1);
l=1;
for i=1:size(parametersF.s,2)
    for j=1:nDrug
        stringM(l) = stringT(j);
        l=l+1;
    end
end

% Draw the plot with p-values
figure()
[~,~]=UnivarScatter(dataPlot,vectorcolor,stringM,'PointSize',80);
%xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('mu')
set(gca,'FontSize',20)
box on

%% tlag+q0 - entry 2 and 3 of parametersF
k=1;
tableP = zeros(nDrug*size(parametersF.s,2),1);
for i=1:size(parametersF.s,2)
    for j=1:nDrug
        if isnan(parametersF.s{i}.p{j}(3)) && ~isnan(parametersF.s{i}.p{j}(2))
            tableP(k) = parametersF.s{i}.p{j}(2);
        elseif isnan(parametersF.s{i}.p{j}(2)) && ~isnan(parametersF.s{i}.p{j}(3))
            tableP(k) = abs(log(1+ 1./parametersF.s{i}.p{j}(3))./parametersF.s{i}.p{j}(4));
        elseif ~isnan(parametersF.s{i}.p{j}(2)) && ~isnan(parametersF.s{i}.p{j}(3))
            tableP(k) = parametersF.s{i}.p{j}(2) + abs(log(1+ 1./parametersF.s{i}.p{j}(3))./parametersF.s{i}.p{j}(4));
        elseif isnan(parametersF.s{i}.p{j}(2)) && isnan(parametersF.s{i}.p{j}(3))
            tableP(k) = 0;
        end

        k=k+1;
    end
end

dataPlot = table();
% Categorical variable
dataPlot.condition = cell(k-1,1);
dataPlot.condition(1:k-1) = {'Lag time [min]'};
dataPlot.condition = categorical(dataPlot.condition);

% Numerical variable
dataPlot.value = zeros(k-1,1);
dataPlot.value = tableP;

%color for strains
nstrains = size(parametersF.s,2);
vectorcolorT = distinguishable_colors(nstrains);
vectorcolor = zeros(k-1,3);
l=1;
for i=1:size(parametersF.s,2)
    for j=1:nDrug
        vectorcolor(l,:) = vectorcolorT(i,:);
        l=l+1;
    end
end

%stringMarker for drugs
%nstrains = size(parametersF.s,2);
stringT = ['o','d','s','p','h','^']; %,'v'
%stringM = string(k-1,1);
l=1;
for i=1:size(parametersF.s,2)
    for j=1:nDrug
        stringM(l) = stringT(j);
        l=l+1;
    end
end

% Draw the plot with p-values
figure()
[~,~]=UnivarScatter(dataPlot,vectorcolor,stringM,'PointSize',80);
%xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('lag time [min]')
set(gca,'FontSize',20)
box on

end

