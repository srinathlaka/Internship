function plotSummary(DataSummary,numberOfStrains,stringMarkerT,strainName,stringMarkerDrug,stringNameDrugs)

%strainswith colors
nstrains=numberOfStrains(end,1);
vectorcolorT = distinguishable_colors(nstrains);

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

aa=1;
    for cn=1:numberOfStrains(end,1)
        for cl=1:numberOfStrains(cn,2)
            vectorcolorTT(aa,:) = vectorcolorT(cn,:);
            aa=aa+1;
        end
    end

vectorcolor = [vectorcolorTT;vectorcolorTT;vectorcolorTT;vectorcolorTT;vectorcolorTT;vectorcolorTT;vectorcolorTT];
%vectorcolorNoDrug = 0.5.*ones(size(vectorcolor,1),size(vectorcolor,2));

%typeDrug with symbols
if numberOfStrains(end,3) ~= size(stringMarkerT,2)
    fprintf('Error, Update drug markers')
    exit()
end
stringMarker = [stringMarkerT,stringMarkerT,stringMarkerT,stringMarkerT,stringMarkerT,stringMarkerT,stringMarkerT];

figure
y = 1:size(stringMarkerDrug,2);
x = ones(1,size(y,2));
for k=1:size(x,2)
    scatter(x(k),y(k),80,'filled',stringMarkerDrug(k),'MarkerFaceColor','k')
    hold on
    labelpoints(x(k),y(k),stringNameDrugs(k),'E',0.2,1.5)
end
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])

%% growth rate
tableMu = [];
for i=1:size(DataSummary.mu,2)
    tableMu = [tableMu;DataSummary.mu{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableMu,1),1);
data.condition(1:size(tableMu,1)) = {'CA'};
data.condition(size(tableMu,1)+1:2*size(tableMu,1)) = {'CBC'};
data.condition(2*size(tableMu,1)+1:3*size(tableMu,1)) = {'CDCA'};
data.condition(3*size(tableMu,1)+1:4*size(tableMu,1)) = {'DCA'};
data.condition(4*size(tableMu,1)+1:5*size(tableMu,1)) = {'LCA'};
data.condition(5*size(tableMu,1)+1:6*size(tableMu,1)) = {'m9'};
data.condition(6*size(tableMu,1)+1:7*size(tableMu,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableMu,1),1);
data.value(1:size(tableMu,1)) = tableMu(:,1);
data.value(size(tableMu,1)+1:2*size(tableMu,1)) = tableMu(:,2);
data.value(2*size(tableMu,1)+1:3*size(tableMu,1)) = tableMu(:,3);
data.value(3*size(tableMu,1)+1:4*size(tableMu,1)) = tableMu(:,4);
data.value(4*size(tableMu,1)+1:5*size(tableMu,1)) = tableMu(:,5);
data.value(5*size(tableMu,1)+1:6*size(tableMu,1)) = tableMu(:,6);
data.value(6*size(tableMu,1)+1:7*size(tableMu,1)) = tableMu(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('mu/mum6 woD wD')
% set(gca,'FontSize',20)
% box on

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
for i=1:size(DataSummary.mu,2)
    tableMu = [tableMu;DataSummary.mu{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableMu,1),1);
data.condition(1:size(tableMu,1)) = {'CA'};
data.condition(size(tableMu,1)+1:2*size(tableMu,1)) = {'CBC'};
data.condition(2*size(tableMu,1)+1:3*size(tableMu,1)) = {'CDCA'};
data.condition(3*size(tableMu,1)+1:4*size(tableMu,1)) = {'DCA'};
data.condition(4*size(tableMu,1)+1:5*size(tableMu,1)) = {'LCA'};
data.condition(5*size(tableMu,1)+1:6*size(tableMu,1)) = {'m9'};
data.condition(6*size(tableMu,1)+1:7*size(tableMu,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableMu,1),1);
data.value(1:size(tableMu,1)) = tableMu(:,1);
data.value(size(tableMu,1)+1:2*size(tableMu,1)) = tableMu(:,2);
data.value(2*size(tableMu,1)+1:3*size(tableMu,1)) = tableMu(:,3);
data.value(3*size(tableMu,1)+1:4*size(tableMu,1)) = tableMu(:,4);
data.value(4*size(tableMu,1)+1:5*size(tableMu,1)) = tableMu(:,5);
data.value(5*size(tableMu,1)+1:6*size(tableMu,1)) = tableMu(:,6);
data.value(6*size(tableMu,1)+1:7*size(tableMu,1)) = tableMu(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('mu/mum6 woD wD')
% set(gca,'FontSize',20)
% box on

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
for i=1:size(DataSummary.Kd,2)
    tableKd = [tableKd;DataSummary.Kd{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableKd,1),1);
data.condition(1:size(tableKd,1)) = {'CA'};
data.condition(size(tableKd,1)+1:2*size(tableKd,1)) = {'CBC'};
data.condition(2*size(tableKd,1)+1:3*size(tableKd,1)) = {'CDCA'};
data.condition(3*size(tableKd,1)+1:4*size(tableKd,1)) = {'DCA'};
data.condition(4*size(tableKd,1)+1:5*size(tableKd,1)) = {'LCA'};
data.condition(5*size(tableKd,1)+1:6*size(tableKd,1)) = {'m9'};
data.condition(6*size(tableKd,1)+1:7*size(tableKd,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableKd,1),1);
data.value(1:size(tableKd,1)) = tableKd(:,1);
data.value(size(tableKd,1)+1:2*size(tableKd,1)) = tableKd(:,2);
data.value(2*size(tableKd,1)+1:3*size(tableKd,1)) = tableKd(:,3);
data.value(3*size(tableKd,1)+1:4*size(tableKd,1)) = tableKd(:,4);
data.value(4*size(tableKd,1)+1:5*size(tableKd,1)) = tableKd(:,5);
data.value(5*size(tableKd,1)+1:6*size(tableKd,1)) = tableKd(:,6);
data.value(6*size(tableKd,1)+1:7*size(tableKd,1)) = tableKd(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Kd/Kdm6 woD wD')
% set(gca,'FontSize',20)
% box on

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
for i=1:size(DataSummary.Odf,2)
    tableOdf = [tableOdf;DataSummary.Odf{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableOdf,1),1);
data.condition(1:size(tableOdf,1)) = {'CA'};
data.condition(size(tableOdf,1)+1:2*size(tableOdf,1)) = {'CBC'};
data.condition(2*size(tableOdf,1)+1:3*size(tableOdf,1)) = {'CDCA'};
data.condition(3*size(tableOdf,1)+1:4*size(tableOdf,1)) = {'DCA'};
data.condition(4*size(tableOdf,1)+1:5*size(tableOdf,1)) = {'LCA'};
data.condition(5*size(tableOdf,1)+1:6*size(tableOdf,1)) = {'m9'};
data.condition(6*size(tableOdf,1)+1:7*size(tableOdf,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableOdf,1),1);
data.value(1:size(tableOdf,1)) = tableOdf(:,1);
data.value(size(tableOdf,1)+1:2*size(tableOdf,1)) = tableOdf(:,2);
data.value(2*size(tableOdf,1)+1:3*size(tableOdf,1)) = tableOdf(:,3);
data.value(3*size(tableOdf,1)+1:4*size(tableOdf,1)) = tableOdf(:,4);
data.value(4*size(tableOdf,1)+1:5*size(tableOdf,1)) = tableOdf(:,5);
data.value(5*size(tableOdf,1)+1:6*size(tableOdf,1)) = tableOdf(:,6);
data.value(6*size(tableOdf,1)+1:7*size(tableOdf,1)) = tableOdf(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Odf/Odfm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Odf/Odfm6')
set(gca,'FontSize',20)
box on

%% final OD with drug

tableOdf = [];
for i=1:size(DataSummary.Odf,2)
    tableOdf = [tableOdf;DataSummary.Odf{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableOdf,1),1);
data.condition(1:size(tableOdf,1)) = {'CA'};
data.condition(size(tableOdf,1)+1:2*size(tableOdf,1)) = {'CBC'};
data.condition(2*size(tableOdf,1)+1:3*size(tableOdf,1)) = {'CDCA'};
data.condition(3*size(tableOdf,1)+1:4*size(tableOdf,1)) = {'DCA'};
data.condition(4*size(tableOdf,1)+1:5*size(tableOdf,1)) = {'LCA'};
data.condition(5*size(tableOdf,1)+1:6*size(tableOdf,1)) = {'m9'};
data.condition(6*size(tableOdf,1)+1:7*size(tableOdf,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableOdf,1),1);
data.value(1:size(tableOdf,1)) = tableOdf(:,1);
data.value(size(tableOdf,1)+1:2*size(tableOdf,1)) = tableOdf(:,2);
data.value(2*size(tableOdf,1)+1:3*size(tableOdf,1)) = tableOdf(:,3);
data.value(3*size(tableOdf,1)+1:4*size(tableOdf,1)) = tableOdf(:,4);
data.value(4*size(tableOdf,1)+1:5*size(tableOdf,1)) = tableOdf(:,5);
data.value(5*size(tableOdf,1)+1:6*size(tableOdf,1)) = tableOdf(:,6);
data.value(6*size(tableOdf,1)+1:7*size(tableOdf,1)) = tableOdf(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Odf/Odfm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Odf/Odfm6 with drug')
set(gca,'FontSize',20)
box on

%% final OD

tableOdDeath = [];
for i=1:size(DataSummary.OdDeath,2)
    tableOdDeath = [tableOdDeath;DataSummary.OdDeath{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableOdDeath,1),1);
data.condition(1:size(tableOdDeath,1)) = {'CA'};
data.condition(size(tableOdDeath,1)+1:2*size(tableOdDeath,1)) = {'CBC'};
data.condition(2*size(tableOdDeath,1)+1:3*size(tableOdDeath,1)) = {'CDCA'};
data.condition(3*size(tableOdDeath,1)+1:4*size(tableOdDeath,1)) = {'DCA'};
data.condition(4*size(tableOdDeath,1)+1:5*size(tableOdDeath,1)) = {'LCA'};
data.condition(5*size(tableOdDeath,1)+1:6*size(tableOdDeath,1)) = {'m9'};
data.condition(6*size(tableOdDeath,1)+1:7*size(tableOdDeath,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableOdDeath,1),1);
data.value(1:size(tableOdDeath,1)) = tableOdDeath(:,1);
data.value(size(tableOdDeath,1)+1:2*size(tableOdDeath,1)) = tableOdDeath(:,2);
data.value(2*size(tableOdDeath,1)+1:3*size(tableOdDeath,1)) = tableOdDeath(:,3);
data.value(3*size(tableOdDeath,1)+1:4*size(tableOdDeath,1)) = tableOdDeath(:,4);
data.value(4*size(tableOdDeath,1)+1:5*size(tableOdDeath,1)) = tableOdDeath(:,5);
data.value(5*size(tableOdDeath,1)+1:6*size(tableOdDeath,1)) = tableOdDeath(:,6);
data.value(6*size(tableOdDeath,1)+1:7*size(tableOdDeath,1)) = tableOdDeath(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('OdDeath/OdDeathm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('OdDeath/OdDeathm6')
set(gca,'FontSize',20)
box on

%% final OD with drug

tableOdDeath = [];
for i=1:size(DataSummary.OdDeath,2)
    tableOdDeath = [tableOdDeath;DataSummary.OdDeath{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableOdDeath,1),1);
data.condition(1:size(tableOdDeath,1)) = {'CA'};
data.condition(size(tableOdDeath,1)+1:2*size(tableOdDeath,1)) = {'CBC'};
data.condition(2*size(tableOdDeath,1)+1:3*size(tableOdDeath,1)) = {'CDCA'};
data.condition(3*size(tableOdDeath,1)+1:4*size(tableOdDeath,1)) = {'DCA'};
data.condition(4*size(tableOdDeath,1)+1:5*size(tableOdDeath,1)) = {'LCA'};
data.condition(5*size(tableOdDeath,1)+1:6*size(tableOdDeath,1)) = {'m9'};
data.condition(6*size(tableOdDeath,1)+1:7*size(tableOdDeath,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableOdDeath,1),1);
data.value(1:size(tableOdDeath,1)) = tableOdDeath(:,1);
data.value(size(tableOdDeath,1)+1:2*size(tableOdDeath,1)) = tableOdDeath(:,2);
data.value(2*size(tableOdDeath,1)+1:3*size(tableOdDeath,1)) = tableOdDeath(:,3);
data.value(3*size(tableOdDeath,1)+1:4*size(tableOdDeath,1)) = tableOdDeath(:,4);
data.value(4*size(tableOdDeath,1)+1:5*size(tableOdDeath,1)) = tableOdDeath(:,5);
data.value(5*size(tableOdDeath,1)+1:6*size(tableOdDeath,1)) = tableOdDeath(:,6);
data.value(6*size(tableOdDeath,1)+1:7*size(tableOdDeath,1)) = tableOdDeath(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('OdDeath/OdDeathm6 woD wD')
% set(gca,'FontSize',20)
% box on

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
for i=1:size(DataSummary.q,2)
    tableq = [tableq;DataSummary.q{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableq,1),1);
data.condition(1:size(tableq,1)) = {'CA'};
data.condition(size(tableq,1)+1:2*size(tableq,1)) = {'CBC'};
data.condition(2*size(tableq,1)+1:3*size(tableq,1)) = {'CDCA'};
data.condition(3*size(tableq,1)+1:4*size(tableq,1)) = {'DCA'};
data.condition(4*size(tableq,1)+1:5*size(tableq,1)) = {'LCA'};
data.condition(5*size(tableq,1)+1:6*size(tableq,1)) = {'m9'};
data.condition(6*size(tableq,1)+1:7*size(tableq,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableq,1),1);
data.value(1:size(tableq,1)) = tableq(:,1);
data.value(size(tableq,1)+1:2*size(tableq,1)) = tableq(:,2);
data.value(2*size(tableq,1)+1:3*size(tableq,1)) = tableq(:,3);
data.value(3*size(tableq,1)+1:4*size(tableq,1)) = tableq(:,4);
data.value(4*size(tableq,1)+1:5*size(tableq,1)) = tableq(:,5);
data.value(5*size(tableq,1)+1:6*size(tableq,1)) = tableq(:,6);
data.value(6*size(tableq,1)+1:7*size(tableq,1)) = tableq(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Q/Qm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Q/Qm6')
set(gca,'FontSize',20)
box on

%% Q lag with drug

tableq = [];
for i=1:size(DataSummary.q,2)
    tableq = [tableq;DataSummary.q{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(tableq,1),1);
data.condition(1:size(tableq,1)) = {'CA'};
data.condition(size(tableq,1)+1:2*size(tableq,1)) = {'CBC'};
data.condition(2*size(tableq,1)+1:3*size(tableq,1)) = {'CDCA'};
data.condition(3*size(tableq,1)+1:4*size(tableq,1)) = {'DCA'};
data.condition(4*size(tableq,1)+1:5*size(tableq,1)) = {'LCA'};
data.condition(5*size(tableq,1)+1:6*size(tableq,1)) = {'m9'};
data.condition(6*size(tableq,1)+1:7*size(tableq,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(tableq,1),1);
data.value(1:size(tableq,1)) = tableq(:,1);
data.value(size(tableq,1)+1:2*size(tableq,1)) = tableq(:,2);
data.value(2*size(tableq,1)+1:3*size(tableq,1)) = tableq(:,3);
data.value(3*size(tableq,1)+1:4*size(tableq,1)) = tableq(:,4);
data.value(4*size(tableq,1)+1:5*size(tableq,1)) = tableq(:,5);
data.value(5*size(tableq,1)+1:6*size(tableq,1)) = tableq(:,6);
data.value(6*size(tableq,1)+1:7*size(tableq,1)) = tableq(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Q/Qm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Q/Qm6 with drug')
set(gca,'FontSize',20)
box on

%% Tdeath

TableTdeath = [];
for i=1:size(DataSummary.Tdeath,2)
    TableTdeath = [TableTdeath;DataSummary.Tdeath{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(TableTdeath,1),1);
data.condition(1:size(TableTdeath,1)) = {'CA'};
data.condition(size(TableTdeath,1)+1:2*size(TableTdeath,1)) = {'CBC'};
data.condition(2*size(TableTdeath,1)+1:3*size(TableTdeath,1)) = {'CDCA'};
data.condition(3*size(TableTdeath,1)+1:4*size(TableTdeath,1)) = {'DCA'};
data.condition(4*size(TableTdeath,1)+1:5*size(TableTdeath,1)) = {'LCA'};
data.condition(5*size(TableTdeath,1)+1:6*size(TableTdeath,1)) = {'m9'};
data.condition(6*size(TableTdeath,1)+1:7*size(TableTdeath,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(TableTdeath,1),1);
data.value(1:size(TableTdeath,1)) = TableTdeath(:,1);
data.value(size(TableTdeath,1)+1:2*size(TableTdeath,1)) = TableTdeath(:,2);
data.value(2*size(TableTdeath,1)+1:3*size(TableTdeath,1)) = TableTdeath(:,3);
data.value(3*size(TableTdeath,1)+1:4*size(TableTdeath,1)) = TableTdeath(:,4);
data.value(4*size(TableTdeath,1)+1:5*size(TableTdeath,1)) = TableTdeath(:,5);
data.value(5*size(TableTdeath,1)+1:6*size(TableTdeath,1)) = TableTdeath(:,6);
data.value(6*size(TableTdeath,1)+1:7*size(TableTdeath,1)) = TableTdeath(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Tdeath/Tdeathm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Tdeath/Tdeathm6')
set(gca,'FontSize',20)
box on

%% Tdeath with drug

TableTdeath = [];
for i=1:size(DataSummary.Tdeath,2)
    TableTdeath = [TableTdeath;DataSummary.Tdeath{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(TableTdeath,1),1);
data.condition(1:size(TableTdeath,1)) = {'CA'};
data.condition(size(TableTdeath,1)+1:2*size(TableTdeath,1)) = {'CBC'};
data.condition(2*size(TableTdeath,1)+1:3*size(TableTdeath,1)) = {'CDCA'};
data.condition(3*size(TableTdeath,1)+1:4*size(TableTdeath,1)) = {'DCA'};
data.condition(4*size(TableTdeath,1)+1:5*size(TableTdeath,1)) = {'LCA'};
data.condition(5*size(TableTdeath,1)+1:6*size(TableTdeath,1)) = {'m9'};
data.condition(6*size(TableTdeath,1)+1:7*size(TableTdeath,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(TableTdeath,1),1);
data.value(1:size(TableTdeath,1)) = TableTdeath(:,1);
data.value(size(TableTdeath,1)+1:2*size(TableTdeath,1)) = TableTdeath(:,2);
data.value(2*size(TableTdeath,1)+1:3*size(TableTdeath,1)) = TableTdeath(:,3);
data.value(3*size(TableTdeath,1)+1:4*size(TableTdeath,1)) = TableTdeath(:,4);
data.value(4*size(TableTdeath,1)+1:5*size(TableTdeath,1)) = TableTdeath(:,5);
data.value(5*size(TableTdeath,1)+1:6*size(TableTdeath,1)) = TableTdeath(:,6);
data.value(6*size(TableTdeath,1)+1:7*size(TableTdeath,1)) = TableTdeath(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('Tdeath/Tdeathm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('Tdeath/Tdeathm6 with drug')
set(gca,'FontSize',20)
box on

%% G

TableG = [];
for i=1:size(DataSummary.G,2)
    TableG = [TableG;DataSummary.G{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(TableG,1),1);
data.condition(1:size(TableG,1)) = {'CA'};
data.condition(size(TableG,1)+1:2*size(TableG,1)) = {'CBC'};
data.condition(2*size(TableG,1)+1:3*size(TableG,1)) = {'CDCA'};
data.condition(3*size(TableG,1)+1:4*size(TableG,1)) = {'DCA'};
data.condition(4*size(TableG,1)+1:5*size(TableG,1)) = {'LCA'};
data.condition(5*size(TableG,1)+1:6*size(TableG,1)) = {'m9'};
data.condition(6*size(TableG,1)+1:7*size(TableG,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(TableG,1),1);
data.value(1:size(TableG,1)) = TableG(:,1);
data.value(size(TableG,1)+1:2*size(TableG,1)) = TableG(:,2);
data.value(2*size(TableG,1)+1:3*size(TableG,1)) = TableG(:,3);
data.value(3*size(TableG,1)+1:4*size(TableG,1)) = TableG(:,4);
data.value(4*size(TableG,1)+1:5*size(TableG,1)) = TableG(:,5);
data.value(5*size(TableG,1)+1:6*size(TableG,1)) = TableG(:,6);
data.value(6*size(TableG,1)+1:7*size(TableG,1)) = TableG(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('G/Gm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('G/Gm6')
set(gca,'FontSize',20)
box on

%% G with drug

TableG = [];
for i=1:size(DataSummary.G,2)
    TableG = [TableG;DataSummary.G{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(TableG,1),1);
data.condition(1:size(TableG,1)) = {'CA'};
data.condition(size(TableG,1)+1:2*size(TableG,1)) = {'CBC'};
data.condition(2*size(TableG,1)+1:3*size(TableG,1)) = {'CDCA'};
data.condition(3*size(TableG,1)+1:4*size(TableG,1)) = {'DCA'};
data.condition(4*size(TableG,1)+1:5*size(TableG,1)) = {'LCA'};
data.condition(5*size(TableG,1)+1:6*size(TableG,1)) = {'m9'};
data.condition(6*size(TableG,1)+1:7*size(TableG,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(TableG,1),1);
data.value(1:size(TableG,1)) = TableG(:,1);
data.value(size(TableG,1)+1:2*size(TableG,1)) = TableG(:,2);
data.value(2*size(TableG,1)+1:3*size(TableG,1)) = TableG(:,3);
data.value(3*size(TableG,1)+1:4*size(TableG,1)) = TableG(:,4);
data.value(4*size(TableG,1)+1:5*size(TableG,1)) = TableG(:,5);
data.value(5*size(TableG,1)+1:6*size(TableG,1)) = TableG(:,6);
data.value(6*size(TableG,1)+1:7*size(TableG,1)) = TableG(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('G/Gm6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('G/Gm6 with drug')
set(gca,'FontSize',20)
box on

%% LagTime

TableLagTime = [];
for i=1:size(DataSummary.LagTime,2)
    TableLagTime = [TableLagTime;DataSummary.LagTime{i}(:,1)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(TableLagTime,1),1);
data.condition(1:size(TableLagTime,1)) = {'CA'};
data.condition(size(TableLagTime,1)+1:2*size(TableLagTime,1)) = {'CBC'};
data.condition(2*size(TableLagTime,1)+1:3*size(TableLagTime,1)) = {'CDCA'};
data.condition(3*size(TableLagTime,1)+1:4*size(TableLagTime,1)) = {'DCA'};
data.condition(4*size(TableLagTime,1)+1:5*size(TableLagTime,1)) = {'LCA'};
data.condition(5*size(TableLagTime,1)+1:6*size(TableLagTime,1)) = {'m9'};
data.condition(6*size(TableLagTime,1)+1:7*size(TableLagTime,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(TableLagTime,1),1);
data.value(1:size(TableLagTime,1)) = TableLagTime(:,1);
data.value(size(TableLagTime,1)+1:2*size(TableLagTime,1)) = TableLagTime(:,2);
data.value(2*size(TableLagTime,1)+1:3*size(TableLagTime,1)) = TableLagTime(:,3);
data.value(3*size(TableLagTime,1)+1:4*size(TableLagTime,1)) = TableLagTime(:,4);
data.value(4*size(TableLagTime,1)+1:5*size(TableLagTime,1)) = TableLagTime(:,5);
data.value(5*size(TableLagTime,1)+1:6*size(TableLagTime,1)) = TableLagTime(:,6);
data.value(6*size(TableLagTime,1)+1:7*size(TableLagTime,1)) = TableLagTime(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('LagTime/LagTimem6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('LagTime/LagTimem6')
set(gca,'FontSize',20)
box on

%% LagTime with drug

TableLagTime = [];
for i=1:size(DataSummary.LagTime,2)
    TableLagTime = [TableLagTime;DataSummary.LagTime{i}(:,2)'];
end

% Create some data
data = table();

% Categorical variable
data.condition = cell(7*size(TableLagTime,1),1);
data.condition(1:size(TableLagTime,1)) = {'CA'};
data.condition(size(TableLagTime,1)+1:2*size(TableLagTime,1)) = {'CBC'};
data.condition(2*size(TableLagTime,1)+1:3*size(TableLagTime,1)) = {'CDCA'};
data.condition(3*size(TableLagTime,1)+1:4*size(TableLagTime,1)) = {'DCA'};
data.condition(4*size(TableLagTime,1)+1:5*size(TableLagTime,1)) = {'LCA'};
data.condition(5*size(TableLagTime,1)+1:6*size(TableLagTime,1)) = {'m9'};
data.condition(6*size(TableLagTime,1)+1:7*size(TableLagTime,1)) = {'UDCA'};
data.condition = categorical(data.condition);


% Numerical variable
data.value = zeros(7*size(TableLagTime,1),1);
data.value(1:size(TableLagTime,1)) = TableLagTime(:,1);
data.value(size(TableLagTime,1)+1:2*size(TableLagTime,1)) = TableLagTime(:,2);
data.value(2*size(TableLagTime,1)+1:3*size(TableLagTime,1)) = TableLagTime(:,3);
data.value(3*size(TableLagTime,1)+1:4*size(TableLagTime,1)) = TableLagTime(:,4);
data.value(4*size(TableLagTime,1)+1:5*size(TableLagTime,1)) = TableLagTime(:,5);
data.value(5*size(TableLagTime,1)+1:6*size(TableLagTime,1)) = TableLagTime(:,6);
data.value(6*size(TableLagTime,1)+1:7*size(TableLagTime,1)) = TableLagTime(:,7);

% Statistical significance
categ_values = categories(data.condition);
reference_category = 'm9';
p_vals = zeros(1,numel(categ_values));


for i = 1:numel(categ_values)
    condition_data = data.value(data.condition==categ_values{i});
    control_data = data.value(data.condition==reference_category);
    [~,p_vals(i)] = kstest2(condition_data,control_data);
end

% % Draw the plot with stars
% figure()
% [x,y]=UnivarScatter(data);
% xtickangle(45)
% drawStars(y,p_vals,[0.05,0.005],1,[],[],{'FontSize',20})
% title('LagTime/LagTimem6 woD wD')
% set(gca,'FontSize',20)
% box on

% Draw the plot with p-values
figure()
[x,y]=UnivarScatter(data,vectorcolor,stringMarker,'PointSize',80);
xtickangle(45)
%drawStars(y,p_vals,[0.05,0.005],1,[],false,{'FontSize',10})
title('LagTime/LagTimem6 with drug')
set(gca,'FontSize',20)
box on

end
