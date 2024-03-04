function plotSummaryDrug(DataSummary,strainOrder,stringMarkerT,stringMarkerBA,stringBAnames,strainName)


%% find drug groups

figure
y = 1:size(stringMarkerBA,2);
x = ones(1,size(y,2));
for k=1:size(x,2)
    scatter(x(k),y(k),80,'filled',stringMarkerBA(k),'MarkerFaceColor','k')
    hold on
    labelpoints(x(k),y(k),stringBAnames(k),'E',0.2,1.5)
end
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])

%bile acids with symbols
%strain
nstrains = max(strainOrder);
vectorcolorT = distinguishable_colors(nstrains);

% (o Cipro, d Mero, s PipTaz, p Tige, h Tocol)
[ciproI] = find(stringMarkerT=='o');
ncipro = size(ciproI,2);
if isempty(ciproI)
    ciproI=0;
    ncipro =1;
end
%stringMarker=repmat('o', [1, 7.*size(ciproI,2)]);
stringMarkerCiproI = repmat(stringMarkerBA, [1, size(ciproI,2)]);
[MeroI] = find(stringMarkerT=='d');
nmero = size(MeroI,2);
if isempty(MeroI)
    MeroI=0;
    nmero=1;
end
%stringMarker=[stringMarker,repmat('d', [1, 7.*size(MeroI,2)])];
stringMarkerMeroI = repmat(stringMarkerBA, [1, size(MeroI,2)]);
[PipTazI] = find(stringMarkerT=='s');
npiptaz = size(PipTazI,2);
if isempty(PipTazI)
    PipTazI=0;
    npiptaz=1;
end
%stringMarker=[stringMarker,repmat('s', [1, 7.*size(PipTazI,2)])];
stringMarkerPipTazI = repmat(stringMarkerBA, [1, size(PipTazI,2)]);
[TigeI] = find(stringMarkerT=='p');
ntige = size(TigeI,2);
if isempty(TigeI)
    TigeI=0;
    ntige=1;
end
%stringMarker=[stringMarker,repmat('p', [1, 7.*size(TigeI,2)])];
stringMarkerTigeI = repmat(stringMarkerBA, [1, size(TigeI,2)]);
[TocolI] = find(stringMarkerT=='h');
ntocol = size(TocolI,2);
if isempty(TocolI)
    TocolI=0;
    ntocol=1;
end
%stringMarker=[stringMarker,repmat('h', [1, 7.*size(TocolI,2)])];
stringMarkerTocolI = repmat(stringMarkerBA, [1, size(TocolI,2)]);

stringMarker = [stringMarkerCiproI stringMarkerMeroI stringMarkerPipTazI stringMarkerTigeI stringMarkerTocolI];
stringMarker = stringMarker';

indexI = [ciproI MeroI PipTazI TigeI TocolI];

%strain color vector
indexS = [];
for l=1:size(indexI,2)
    if indexI(l)~=0
        indexS = [indexS,strainOrder(indexI(l)).*ones(1,7)];
    else
        indexS = [indexS,zeros(1,7)];
    end
end

vectorcolor = zeros(size(indexS,2),3);
for n=1:size(indexS,2)
    if indexS(n)~=0
        vectorcolor(n,:) = vectorcolorT(indexS(n),:);
    else
        vectorcolor(n,:) = zeros(1,3);
    end
end

figure
x = ones(1,size(vectorcolorT,1)); 
b = bar(1,x,"stacked");
b(1).BarWidth = 0.25;
for k=1:size(vectorcolorT,1)
    b(k).FaceColor = vectorcolorT(k,:);
end
legend(strainName,'location','northwest')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])

%vectorcolorNoDrug = 0.5.*ones(size(vectorcolor,1),size(vectorcolor,2));

%% growth rate
tableMu = [];
[a,b] = size(DataSummary.mu{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableMu = [tableMu;DataSummary.mu{indexI(i)}(:,1)'];
    else
        tableMu = [tableMu;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableMu,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableMuT = tableMu';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableMuT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableMuT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableMuT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableMuT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableMuT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('mu/mum6')
set(gca,'FontSize',20)
box on

%% growth rate with drug
tableMu = [];
[a,b] = size(DataSummary.mu{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableMu = [tableMu;DataSummary.mu{indexI(i)}(:,2)'];
    else
        tableMu = [tableMu;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableMu,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableMuT = tableMu';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableMuT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableMuT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableMuT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableMuT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableMuT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('mu/mum6 with drug')
set(gca,'FontSize',20)
box on

%% drug death rate
tableKd = [];
[a,b] = size(DataSummary.Kd{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableKd = [tableKd;DataSummary.Kd{indexI(i)}(:,1)'];
    else
        tableKd = [tableKd;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableKd,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableKdT = tableKd';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableKdT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableKdT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableKdT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableKdT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableKdT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Kd/Kdm6 with drug')
set(gca,'FontSize',20)
box on

%% final OD
tableOdf = [];
[a,b] = size(DataSummary.Odf{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableOdf = [tableOdf;DataSummary.Odf{indexI(i)}(:,1)'];
    else
        tableOdf = [tableOdf;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableOdf,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableOdfT = tableOdf';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableOdfT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableOdfT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableOdfT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableOdfT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableOdfT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Odf/Odfm6')
set(gca,'FontSize',20)
box on

%% final OD with drug

%% final OD
tableOdf = [];
[a,b] = size(DataSummary.Odf{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableOdf = [tableOdf;DataSummary.Odf{indexI(i)}(:,2)'];
    else
        tableOdf = [tableOdf;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableOdf,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableOdfT = tableOdf';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableOdfT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableOdfT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableOdfT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableOdfT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableOdfT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Odf/Odfm6 with drug')
set(gca,'FontSize',20)
box on

%% OD at death
tableOdDeath = [];
[a,b] = size(DataSummary.OdDeath{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableOdDeath = [tableOdDeath;DataSummary.OdDeath{indexI(i)}(:,1)'];
    else
        tableOdDeath = [tableOdDeath;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableOdDeath,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableOdDeathT = tableOdDeath';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableOdDeathT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableOdDeathT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableOdDeathT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableOdDeathT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableOdDeathT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('OdDeath/OdDeathm6')
set(gca,'FontSize',20)
box on

%% OD at death with drug

tableOdDeath = [];
[a,b] = size(DataSummary.OdDeath{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableOdDeath = [tableOdDeath;DataSummary.OdDeath{indexI(i)}(:,2)'];
    else
        tableOdDeath = [tableOdDeath;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableOdDeath,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableOdDeathT = tableOdDeath';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableOdDeathT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableOdDeathT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableOdDeathT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableOdDeathT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableOdDeathT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('OdDeath/OdDeathm6 with drug')
set(gca,'FontSize',20)
box on


%% Q lag
tableq = [];
[a,b] = size(DataSummary.q{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableq = [tableq;DataSummary.q{indexI(i)}(:,1)'];
    else
        tableq = [tableq;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableq,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableqT = tableq';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableqT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableqT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableqT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableqT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableqT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('q/qm6')
set(gca,'FontSize',20)
box on

%% Q lag with drug
tableq = [];
[a,b] = size(DataSummary.q{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableq = [tableq;DataSummary.q{indexI(i)}(:,2)'];
    else
        tableq = [tableq;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableq,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableqT = tableq';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableqT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableqT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableqT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableqT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableqT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('q/qm6 with drug')
set(gca,'FontSize',20)
box on

%% Tdeath
tableTdeath = [];
[a,b] = size(DataSummary.Tdeath{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableTdeath = [tableTdeath;DataSummary.Tdeath{indexI(i)}(:,1)'];
    else
        tableTdeath = [tableTdeath;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableTdeath,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableTdeathT = tableTdeath';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableTdeathT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableTdeathT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableTdeathT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableTdeathT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableTdeathT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Tdeath/Tdeathm6')
set(gca,'FontSize',20)
box on

%% Tdeath with drug
tableTdeath = [];
[a,b] = size(DataSummary.Tdeath{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableTdeath = [tableTdeath;DataSummary.Tdeath{indexI(i)}(:,2)'];
    else
        tableTdeath = [tableTdeath;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableTdeath,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableTdeathT = tableTdeath';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableTdeathT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableTdeathT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableTdeathT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableTdeathT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableTdeathT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Tdeath/Tdeathm6 with drug')
set(gca,'FontSize',20)
box on

%% G
tableG = [];
[a,b] = size(DataSummary.G{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableG = [tableG;DataSummary.G{indexI(i)}(:,1)'];
    else
        tableG = [tableG;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableG,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableGT = tableG';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableGT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableGT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableGT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableGT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableGT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('G/Gm6')
set(gca,'FontSize',20)
box on
%% G with drug
tableG = [];
[a,b] = size(DataSummary.G{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableG = [tableG;DataSummary.G{indexI(i)}(:,2)'];
    else
        tableG = [tableG;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableG,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableGT = tableG';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableGT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableGT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableGT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableGT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableGT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('G/Gm6 with drug')
set(gca,'FontSize',20)
box on

%% LagTime
tableLagTime = [];
[a,b] = size(DataSummary.LagTime{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableLagTime = [tableLagTime;DataSummary.LagTime{indexI(i)}(:,1)'];
    else
        tableLagTime = [tableLagTime;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableLagTime,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableLagTimeT = tableLagTime';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableLagTimeT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableLagTimeT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableLagTimeT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableLagTimeT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableLagTimeT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('LagTime/LagTimem6')
set(gca,'FontSize',20)
box on

%% LagTime with drug
tableLagTime = [];
[a,b] = size(DataSummary.LagTime{1}(:,1)');
for i=1:size(indexI,2)
    if indexI(i)~=0
        tableLagTime = [tableLagTime;DataSummary.LagTime{indexI(i)}(:,2)'];
    else
        tableLagTime = [tableLagTime;ones(a,b)];
    end
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(5*size(tableLagTime,1),1);
data.condition(1:7.*ncipro) = {'Cipro'};
data.condition(7.*ncipro+1:7.*ncipro+7.*nmero) = {'Mero'};
data.condition(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = {'PipTaz'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = {'Tige'};
data.condition(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = {'Tocol'};
data.condition = categorical(data.condition);


% Numerical variable
tableLagTimeT = tableLagTime';
data.value = zeros(size(data.condition,1),1);
data.value(1:7.*ncipro) = tableLagTimeT(1:7.*ncipro);
data.value(7.*ncipro+1:7.*ncipro+7.*nmero) = tableLagTimeT(7.*ncipro+1:7.*ncipro+7.*nmero);
data.value(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz) = tableLagTimeT(7.*ncipro+7.*nmero+1:7.*ncipro+7.*nmero+7.*npiptaz);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige) = tableLagTimeT(7.*ncipro+7.*nmero+7.*npiptaz+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige);
data.value(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol) = tableLagTimeT(7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+1:7.*ncipro+7.*nmero+7.*npiptaz+7.*ntige+7.*ntocol);

% % Statistical significance
% categ_values = categories(data.condition);
% reference_category = 'm9';
% p_vals = zeros(1,numel(categ_values));
% 
% 
% for i = 1:numel(categ_values)
%     condition_data = data.value(data.condition==categ_values{i});
%     control_data = data.value(data.condition==reference_category);
%     [~,p_vals(i)] = kstest2(condition_data,control_data);
% end

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('LagTime/LagTimem6 with drug')
set(gca,'FontSize',20)
box on

end
