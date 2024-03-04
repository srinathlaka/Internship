function plotResults(DataDrug,parametersDrug)

%% plot all
figure
%m9
plot(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,'--','LineWidth',1,'Color','r');
hold on
scatter(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,DataDrug.m9.Xstd);

plot(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,10,'k','filled');

text(DataDrug.m9.time(end),DataDrug.m9.Xfit(end),"m9",'Color','r');

plot(DataDrug.m9drug.time,DataDrug.m9drug.XmeanSmooth,'--','LineWidth',1,'Color','r');
hold on
scatter(DataDrug.m9drug.time,DataDrug.m9drug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.m9drug.time,DataDrug.m9drug.XmeanSmooth,DataDrug.m9.Xstd);

plot(DataDrug.m9drug.time(1:size(DataDrug.m9drug.Xfit,1)),DataDrug.m9drug.Xfit,'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.m9drug.time(1:size(DataDrug.m9drug.Xfit,1)),DataDrug.m9drug.Xfit,10,'k','filled');

text(DataDrug.m9drug.time(end),DataDrug.m9drug.Xfit(end),"m9drug",'Color','r');

%CA
plot(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,'--','LineWidth',1,'Color','g');
hold on
scatter(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,DataDrug.CA.Xstd);

plot(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),'-','LineWidth',2,'Color','g');
hold on
scatter(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),10,'k','filled');

text(DataDrug.CA.time(end),DataDrug.CA.Xfit(end),"CA",'Color','g');

plot(DataDrug.CAdrug.time,DataDrug.CAdrug.XmeanSmooth,'--','LineWidth',1,'Color','g');
hold on
scatter(DataDrug.CAdrug.time,DataDrug.CAdrug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CAdrug.time,DataDrug.CAdrug.XmeanSmooth,DataDrug.CAdrug.Xstd);

plot(DataDrug.CAdrug.time(1:size(DataDrug.CAdrug.Xfit,1)),DataDrug.CAdrug.Xfit(:,1),'-','LineWidth',2,'Color','g');
hold on
scatter(DataDrug.CAdrug.time(1:size(DataDrug.CAdrug.Xfit,1)),DataDrug.CAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.CAdrug.time(end),DataDrug.CAdrug.Xfit(end),"CAdrug",'Color','g');

%CDCA
plot(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,'--','LineWidth',1,'Color','b');
hold on
scatter(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,DataDrug.CDCA.Xstd);

plot(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),'-','LineWidth',2,'Color','b');
hold on
scatter(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),10,'k','filled');

text(DataDrug.CDCA.time(end),DataDrug.CDCA.Xfit(end),"CDCA",'Color','b');

plot(DataDrug.CDCAdrug.time,DataDrug.CDCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','b');
hold on
scatter(DataDrug.CDCAdrug.time,DataDrug.CDCAdrug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CDCAdrug.time,DataDrug.CDCAdrug.XmeanSmooth,DataDrug.CDCAdrug.Xstd);

plot(DataDrug.CDCAdrug.time(1:size(DataDrug.CDCAdrug.Xfit,1)),DataDrug.CDCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','b');
hold on
scatter(DataDrug.CDCAdrug.time(1:size(DataDrug.CDCAdrug.Xfit,1)),DataDrug.CDCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.CDCAdrug.time(end),DataDrug.CDCAdrug.Xfit(end),"CDCAdrug",'Color','b');

%DCA
plot(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,'--','LineWidth',1,'Color','c');
hold on
scatter(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,DataDrug.DCA.Xstd);

plot(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),'-','LineWidth',2,'Color','c');
hold on
scatter(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),10,'k','filled');

text(DataDrug.DCA.time(end),DataDrug.DCA.Xfit(end),"DCA",'Color','c');

plot(DataDrug.DCAdrug.time,DataDrug.DCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','c');
hold on
scatter(DataDrug.DCAdrug.time,DataDrug.DCAdrug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.DCAdrug.time,DataDrug.DCAdrug.XmeanSmooth,DataDrug.DCAdrug.Xstd);

plot(DataDrug.DCAdrug.time(1:size(DataDrug.DCAdrug.Xfit,1)),DataDrug.DCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','c');
hold on
scatter(DataDrug.DCAdrug.time(1:size(DataDrug.DCAdrug.Xfit,1)),DataDrug.DCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.DCAdrug.time(end),DataDrug.DCAdrug.Xfit(end),"DCAdrug",'Color','c');

%LCA
plot(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,'--','LineWidth',1,'Color','m');
hold on
scatter(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,DataDrug.LCA.Xstd);

plot(DataDrug.LCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),'-','LineWidth',2,'Color','m');
hold on
scatter(DataDrug.LCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),10,'k','filled');

text(DataDrug.LCA.time(end),DataDrug.LCA.Xfit(end),"LCA",'Color','m');

plot(DataDrug.LCAdrug.time,DataDrug.LCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','m');
hold on
scatter(DataDrug.LCAdrug.time,DataDrug.LCAdrug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.LCAdrug.time,DataDrug.LCAdrug.XmeanSmooth,DataDrug.LCAdrug.Xstd);

plot(DataDrug.LCAdrug.time(1:size(DataDrug.LCAdrug.Xfit,1)),DataDrug.LCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','m');
hold on
scatter(DataDrug.LCAdrug.time(1:size(DataDrug.LCAdrug.Xfit,1)),DataDrug.LCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.LCAdrug.time(end),DataDrug.LCAdrug.Xfit(end),"LCAdrug",'Color','m');

%UDCA
plot(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,'--','LineWidth',1,'Color','y');
hold on
scatter(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,DataDrug.UDCA.Xstd);

plot(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),'-','LineWidth',2,'Color','y');
hold on
scatter(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),10,'k','filled');

text(DataDrug.UDCA.time(end),DataDrug.UDCA.Xfit(end),"UDCA",'Color','y');

plot(DataDrug.UDCAdrug.time,DataDrug.UDCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','y');
hold on
scatter(DataDrug.UDCAdrug.time,DataDrug.UDCAdrug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.UDCAdrug.time,DataDrug.UDCAdrug.XmeanSmooth,DataDrug.UDCAdrug.Xstd);

plot(DataDrug.UDCAdrug.time(1:size(DataDrug.UDCAdrug.Xfit,1)),DataDrug.UDCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','y');
hold on
scatter(DataDrug.UDCAdrug.time(1:size(DataDrug.UDCAdrug.Xfit,1)),DataDrug.UDCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.UDCAdrug.time(end),DataDrug.UDCAdrug.Xfit(end),"UDCAdrug",'Color','y');

%CBC
plot(DataDrug.CBC.time,DataDrug.CBC.XmeanSmooth,'--','LineWidth',1,'Color','k');
hold on
scatter(DataDrug.CBC.time,DataDrug.CBC.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CBC.time,DataDrug.CBC.XmeanSmooth,DataDrug.CBC.Xstd);

plot(DataDrug.CBC.time(1:size(DataDrug.CBC.Xfit,1)),DataDrug.CBC.Xfit(:,1),'-','LineWidth',2,'Color','k');
hold on
scatter(DataDrug.CBC.time(1:size(DataDrug.CBC.Xfit,1)),DataDrug.CBC.Xfit(:,1),10,'k','filled');

text(DataDrug.CBC.time(end),DataDrug.CBC.Xfit(end),"CBC",'Color','k');

plot(DataDrug.CBCdrug.time,DataDrug.CBCdrug.XmeanSmooth,'--','LineWidth',1,'Color','k');
hold on
scatter(DataDrug.CBCdrug.time,DataDrug.CBCdrug.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CBCdrug.time,DataDrug.CBCdrug.XmeanSmooth,DataDrug.CBCdrug.Xstd);

plot(DataDrug.CBCdrug.time(1:size(DataDrug.CBCdrug.Xfit,1)),DataDrug.CBCdrug.Xfit(:,1),'-','LineWidth',2,'Color','k');
hold on
scatter(DataDrug.CBCdrug.time(1:size(DataDrug.CBCdrug.Xfit,1)),DataDrug.CBCdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.CBCdrug.time(end),DataDrug.CBCdrug.Xfit(end),"CBCdrug",'Color','k');

xline(parametersDrug.CBC.tdrug);

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight


%% without errorbar

figure
%m9
plot(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,'--','LineWidth',1,'Color','r');
hold on
%scatter(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,DataDrug.m9.Xstd);

plot(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,'-','LineWidth',2,'Color','r');
hold on
%scatter(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,10,'k','filled');

text(DataDrug.m9.time(end),DataDrug.m9.Xfit(end),"m9",'Color','r');

plot(DataDrug.m9drug.time,DataDrug.m9drug.XmeanSmooth,'--','LineWidth',1,'Color','r');
hold on
%scatter(DataDrug.m9drug.time,DataDrug.m9drug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.m9drug.time,DataDrug.m9drug.XmeanSmooth,DataDrug.m9.Xstd);

plot(DataDrug.m9drug.time(1:size(DataDrug.m9drug.Xfit,1)),DataDrug.m9drug.Xfit,'-','LineWidth',2,'Color','r');
hold on
%scatter(DataDrug.m9drug.time(1:size(DataDrug.m9drug.Xfit,1)),DataDrug.m9drug.Xfit,10,'k','filled');

text(DataDrug.m9drug.time(end),DataDrug.m9drug.Xfit(end),"m9drug",'Color','r');

%CA
plot(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,'--','LineWidth',1,'Color','g');
hold on
%scatter(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,DataDrug.CA.Xstd);

plot(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),'-','LineWidth',2,'Color','g');
hold on
%scatter(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),10,'k','filled');

text(DataDrug.CA.time(end),DataDrug.CA.Xfit(end),"CA",'Color','g');

plot(DataDrug.CAdrug.time,DataDrug.CAdrug.XmeanSmooth,'--','LineWidth',1,'Color','g');
hold on
%scatter(DataDrug.CAdrug.time,DataDrug.CAdrug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.CAdrug.time,DataDrug.CAdrug.XmeanSmooth,DataDrug.CAdrug.Xstd);

plot(DataDrug.CAdrug.time(1:size(DataDrug.CAdrug.Xfit,1)),DataDrug.CAdrug.Xfit(:,1),'-','LineWidth',2,'Color','g');
hold on
%scatter(DataDrug.CAdrug.time(1:size(DataDrug.CAdrug.Xfit,1)),DataDrug.CAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.CAdrug.time(end),DataDrug.CAdrug.Xfit(end),"CAdrug",'Color','g');

%CDCA
plot(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,'--','LineWidth',1,'Color','b');
hold on
%scatter(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,DataDrug.CDCA.Xstd);

plot(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),'-','LineWidth',2,'Color','b');
hold on
%scatter(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),10,'k','filled');

text(DataDrug.CDCA.time(end),DataDrug.CDCA.Xfit(end),"CDCA",'Color','b');

plot(DataDrug.CDCAdrug.time,DataDrug.CDCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','b');
hold on
%scatter(DataDrug.CDCAdrug.time,DataDrug.CDCAdrug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.CDCAdrug.time,DataDrug.CDCAdrug.XmeanSmooth,DataDrug.CDCAdrug.Xstd);

plot(DataDrug.CDCAdrug.time(1:size(DataDrug.CDCAdrug.Xfit,1)),DataDrug.CDCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','b');
hold on
%scatter(DataDrug.CDCAdrug.time(1:size(DataDrug.CDCAdrug.Xfit,1)),DataDrug.CDCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.CDCAdrug.time(end),DataDrug.CDCAdrug.Xfit(end),"CDCAdrug",'Color','b');

%DCA
plot(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,'--','LineWidth',1,'Color','c');
hold on
%scatter(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,DataDrug.DCA.Xstd);

plot(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),'-','LineWidth',2,'Color','c');
hold on
%scatter(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),10,'k','filled');

text(DataDrug.DCA.time(end),DataDrug.DCA.Xfit(end),"DCA",'Color','c');

plot(DataDrug.DCAdrug.time,DataDrug.DCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','c');
hold on
%scatter(DataDrug.DCAdrug.time,DataDrug.DCAdrug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.DCAdrug.time,DataDrug.DCAdrug.XmeanSmooth,DataDrug.DCAdrug.Xstd);

plot(DataDrug.DCAdrug.time(1:size(DataDrug.DCAdrug.Xfit,1)),DataDrug.DCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','c');
hold on
%scatter(DataDrug.DCAdrug.time(1:size(DataDrug.DCAdrug.Xfit,1)),DataDrug.DCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.DCAdrug.time(end),DataDrug.DCAdrug.Xfit(end),"DCAdrug",'Color','c');

%LCA
plot(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,'--','LineWidth',1,'Color','m');
hold on
%scatter(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,DataDrug.LCA.Xstd);

plot(DataDrug.LCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),'-','LineWidth',2,'Color','m');
hold on
%scatter(DataDrug.LCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),10,'k','filled');

text(DataDrug.LCA.time(end),DataDrug.LCA.Xfit(end),"LCA",'Color','m');

plot(DataDrug.LCAdrug.time,DataDrug.LCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','m');
hold on
%scatter(DataDrug.LCAdrug.time,DataDrug.LCAdrug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.LCAdrug.time,DataDrug.LCAdrug.XmeanSmooth,DataDrug.LCAdrug.Xstd);

plot(DataDrug.LCAdrug.time(1:size(DataDrug.LCAdrug.Xfit,1)),DataDrug.LCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','m');
hold on
%scatter(DataDrug.LCAdrug.time(1:size(DataDrug.LCAdrug.Xfit,1)),DataDrug.LCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.LCAdrug.time(end),DataDrug.LCAdrug.Xfit(end),"LCAdrug",'Color','m');

%UDCA
plot(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,'--','LineWidth',1,'Color','y');
hold on
%scatter(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,DataDrug.UDCA.Xstd);

plot(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),'-','LineWidth',2,'Color','y');
hold on
%scatter(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),10,'k','filled');

text(DataDrug.UDCA.time(end),DataDrug.UDCA.Xfit(end),"UDCA",'Color','y');

plot(DataDrug.UDCAdrug.time,DataDrug.UDCAdrug.XmeanSmooth,'--','LineWidth',1,'Color','y');
hold on
%scatter(DataDrug.UDCAdrug.time,DataDrug.UDCAdrug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.UDCAdrug.time,DataDrug.UDCAdrug.XmeanSmooth,DataDrug.UDCAdrug.Xstd);

plot(DataDrug.UDCAdrug.time(1:size(DataDrug.UDCAdrug.Xfit,1)),DataDrug.UDCAdrug.Xfit(:,1),'-','LineWidth',2,'Color','y');
hold on
%scatter(DataDrug.UDCAdrug.time(1:size(DataDrug.UDCAdrug.Xfit,1)),DataDrug.UDCAdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.UDCAdrug.time(end),DataDrug.UDCAdrug.Xfit(end),"UDCAdrug",'Color','y');

%CBC
plot(DataDrug.CBC.time,DataDrug.CBC.XmeanSmooth,'--','LineWidth',1,'Color','k');
hold on
scatter(DataDrug.CBC.time,DataDrug.CBC.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.UDCCBCA.time,DataDrug.CBC.XmeanSmooth,DataDrug.CBC.Xstd);

plot(DataDrug.CBC.time(1:size(DataDrug.CBC.Xfit,1)),DataDrug.CBC.Xfit(:,1),'-','LineWidth',2,'Color','k');
hold on
%scatter(DataDrug.CBC.time(1:size(DataDrug.CBC.Xfit,1)),DataDrug.CBC.Xfit(:,1),10,'k','filled');

text(DataDrug.CBC.time(end),DataDrug.CBC.Xfit(end),"CBC",'Color','k');

plot(DataDrug.CBCdrug.time,DataDrug.CBCdrug.XmeanSmooth,'--','LineWidth',1,'Color','k');
hold on
%scatter(DataDrug.CBCdrug.time,DataDrug.CBCdrug.XmeanSmooth,10,'k','filled');
%errorbar(DataDrug.CBCdrug.time,DataDrug.CBCdrug.XmeanSmooth,DataDrug.CBCdrug.Xstd);

plot(DataDrug.CBCdrug.time(1:size(DataDrug.CBCdrug.Xfit,1)),DataDrug.CBCdrug.Xfit(:,1),'-','LineWidth',2,'Color','k');
hold on
%scatter(DataDrug.CBCdrug.time(1:size(DataDrug.CBCdrug.Xfit,1)),DataDrug.CBCdrug.Xfit(:,1),10,'k','filled');

text(DataDrug.CBCdrug.time(end),DataDrug.CBCdrug.Xfit(end),"CBCdrug",'Color','k');

xline(parametersDrug.CBC.tdrug);

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight


%% plot fit

figure
%m9
plot(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,'-','LineWidth',2,'Color','r');
hold on
%scatter(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,10,'k','filled');
text(DataDrug.m9.time(end),DataDrug.m9.Xfit(end),"m9",'Color','r');

%m9 drug
plot(DataDrug.m9drug.time(1:size(DataDrug.m9drug.Xfit,1)),DataDrug.m9drug.Xfit,'--','LineWidth',2,'Color','r');
hold on
%scatter(DataDrug.m9drug.time(1:size(DataDrug.m9drug.Xfit,1)),DataDrug.m9drug.Xfit,10,'k','filled');
text(DataDrug.m9drug.time(end),DataDrug.m9drug.Xfit(end),"m9drug",'Color','r');

%CA
plot(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),'-','LineWidth',2,'Color','g');
hold on
%scatter(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),10,'k','filled');
text(DataDrug.CA.time(end),DataDrug.CA.Xfit(end),"CA",'Color','g');

%CA cipro
plot(DataDrug.CAdrug.time(1:size(DataDrug.CAdrug.Xfit,1)),DataDrug.CAdrug.Xfit(:,1),'--','LineWidth',2,'Color','g');
hold on
%scatter(DataDrug.CAdrug.time(1:size(DataDrug.CAdrug.Xfit,1)),DataDrug.CAdrug.Xfit(:,1),10,'k','filled');
text(DataDrug.CAdrug.time(end),DataDrug.CAdrug.Xfit(end),"CAdrug",'Color','g');

%CDCA
plot(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),'-','LineWidth',2,'Color','b');
hold on
%scatter(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),10,'k','filled');
text(DataDrug.CDCA.time(end),DataDrug.CDCA.Xfit(end),"CDCA",'Color','b');

%CDCA cipro
plot(DataDrug.CDCAdrug.time(1:size(DataDrug.CDCAdrug.Xfit,1)),DataDrug.CDCAdrug.Xfit(:,1),'--','LineWidth',2,'Color','b');
hold on
%scatter(DataDrug.CDCAdrug.time(1:size(DataDrug.CDCAdrug.Xfit,1)),DataDrug.CDCAdrug.Xfit(:,1),10,'k','filled');
text(DataDrug.CDCAdrug.time(end),DataDrug.CDCAdrug.Xfit(end),"CDCAdrug",'Color','b');

%DCA
plot(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),'-','LineWidth',2,'Color','c');
hold on
%scatter(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),10,'k','filled');
text(DataDrug.DCA.time(end),DataDrug.DCA.Xfit(end),"DCA",'Color','c');

%DCA cipro
plot(DataDrug.DCAdrug.time(1:size(DataDrug.DCAdrug.Xfit,1)),DataDrug.DCAdrug.Xfit(:,1),'--','LineWidth',2,'Color','c');
hold on
%scatter(DataDrug.DCAdrug.time(1:size(DataDrug.DCAdrug.Xfit,1)),DataDrug.DCAdrug.Xfit(:,1),10,'k','filled');
text(DataDrug.DCAdrug.time(end),DataDrug.DCAdrug.Xfit(end),"DCAdrug",'Color','c');

%LCA
plot(DataDrug.LCA.time(1:size(DataDrug.LCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),'-','LineWidth',2,'Color','m');
hold on
%scatter(DataDrug.LCA.time(1:size(DataDrug.LCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),10,'k','filled');
text(DataDrug.LCA.time(end),DataDrug.LCA.Xfit(end),"LCA",'Color','k');

%LCA cipro
plot(DataDrug.LCAdrug.time(1:size(DataDrug.LCAdrug.Xfit,1)),DataDrug.LCAdrug.Xfit(:,1),'--','LineWidth',2,'Color','m');
hold on
%scatter(DataDrug.LCAdrug.time(1:size(DataDrug.LCAdrug.Xfit,1)),DataDrug.LCAdrug.Xfit(:,1),10,'k','filled');
text(DataDrug.LCAdrug.time(end),DataDrug.LCAdrug.Xfit(end),"LCAdrug",'Color','m');

%UDCA
plot(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),'-','LineWidth',2,'Color','y');
hold on
%scatter(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),10,'k','filled');
text(DataDrug.UDCA.time(end),DataDrug.UDCA.Xfit(end),"UDCA",'Color','y');

%UDCA cipro
plot(DataDrug.UDCAdrug.time(1:size(DataDrug.UDCAdrug.Xfit,1)),DataDrug.UDCAdrug.Xfit(:,1),'--','LineWidth',2,'Color','y');
hold on
%scatter(DataDrug.UDCAdrug.time(1:size(DataDrug.UDCAdrug.Xfit,1)),DataDrug.UDCAdrug.Xfit(:,1),10,'k','filled');
text(DataDrug.UDCAdrug.time(end),DataDrug.UDCAdrug.Xfit(end),"UDCAdrug",'Color','y');

%CBC
plot(DataDrug.CBC.time(1:size(DataDrug.CBC.Xfit,1)),DataDrug.CBC.Xfit(:,1),'-','LineWidth',2,'Color','k');
hold on
%scatter(DataDrug.CBC.time(1:size(DataDrug.CBC.Xfit,1)),DataDrug.CBC.Xfit(:,1),10,'k','filled');
text(DataDrug.CBC.time(end),DataDrug.CBC.Xfit(end),"CBC",'Color','k');

%CBC
plot(DataDrug.CBCdrug.time(1:size(DataDrug.CBCdrug.Xfit,1)),DataDrug.CBCdrug.Xfit(:,1),'--','LineWidth',2,'Color','k');
hold on
%scatter(DataDrug.CBCdrug.time(1:size(DataDrug.CBCdrug.Xfit,1)),DataDrug.CBCdrug.Xfit(:,1),10,'k','filled');
text(DataDrug.CBCdrug.time(end),DataDrug.CBCdrug.Xfit(end),"CBCdrug",'Color','k');

xline(parametersDrug.CBC.tdrug);

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

%%
Q = [parametersDrug.CA.q0,parametersDrug.CBC.q0,parametersDrug.CDCA.q0,parametersDrug.DCA.q0,parametersDrug.LCA.q0,parametersDrug.m9.q0,parametersDrug.UDCA.q0];
%mu
M = [parametersDrug.CA.mu0,parametersDrug.CBC.mu0,parametersDrug.CDCA.mu0,parametersDrug.DCA.mu0,parametersDrug.LCA.mu0,parametersDrug.m9.mu0,parametersDrug.UDCA.mu0];
K = [parametersDrug.CA.k0,parametersDrug.CBC.k0,parametersDrug.CDCA.k0,parametersDrug.DCA.k0,parametersDrug.LCA.k0,parametersDrug.m9.k0,parametersDrug.UDCA.k0];
X0 = [parametersDrug.CA.x0,parametersDrug.CBC.x0,parametersDrug.CDCA.x0,parametersDrug.DCA.x0,parametersDrug.LCA.x0,parametersDrug.m9.x0,parametersDrug.UDCA.x0];

Qd = [parametersDrug.CAdrug.q0,parametersDrug.CBCdrug.q0,parametersDrug.CDCAdrug.q0,parametersDrug.DCAdrug.q0,parametersDrug.LCAdrug.q0,parametersDrug.m9drug.q0,parametersDrug.UDCAdrug.q0];
Md = [parametersDrug.CAdrug.mu0,parametersDrug.CBCdrug.mu0,parametersDrug.CDCAdrug.mu0,parametersDrug.DCAdrug.mu0,parametersDrug.LCA.mu0,parametersDrug.m9drug.mu0,parametersDrug.UDCAdrug.mu0];
%kd drug
Dd = [parametersDrug.CAdrug.d0,parametersDrug.CBCdrug.d0,parametersDrug.CDCAdrug.d0,parametersDrug.DCAdrug.d0,parametersDrug.LCAdrug.d0,parametersDrug.m9drug.d0,parametersDrug.UDCAdrug.d0];
Kd = [parametersDrug.CAdrug.k0,parametersDrug.CBCdrug.k0,parametersDrug.CDCAdrug.k0,parametersDrug.DCAdrug.k0,parametersDrug.LCAdrug.k0,parametersDrug.m9drug.k0,parametersDrug.UDCAdrug.k0];
X0d = [parametersDrug.CAdrug.x0,parametersDrug.CBCdrug.x0,parametersDrug.CDCAdrug.x0,parametersDrug.DCAdrug.x0,parametersDrug.LCAdrug.x0,parametersDrug.m9drug.x0,parametersDrug.UDCAdrug.x0];

figure
scatter(Q,Qd,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[Q,Qdrug]')
text(Q,Qd,["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);

figure
scatter(M,Md,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[mu, muDrug]')
text(M,Md,["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);

figure
scatter(Qd,Dd,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[Qdrug, kdDrug]')
text(Qd,Dd,["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);

figure
scatter(M,Dd,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[mu, kdDrug]')
text(M,Dd,["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);

% figure
% scatter(K,Kd,50,'r','filled');
% hold on
% plot(xlim,ylim,'-b')
% title('[K, Kdrug]')
% text(K,Kd,["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);
% 
% figure
% scatter(K./K(6),Kd./Kd(6),50,'r','filled');
% hold on
% plot(xlim,ylim,'-b')
% title('[K/Km9, Kdrug/Kdrugm9]')
% text(K./K(6),Kd./Kd(6),["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);
% 
% figure
% scatter(K-X0,Kd-X0d,50,'r','filled');
% hold on
% plot(xlim,ylim,'-b')
% title('[K-X0,Kd-X0d]')
% text(K-X0,Kd-X0d,["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);
% 
% figure
% scatter(K./K(6),Kd./Kd(6),50,'r','filled');
% hold on
% plot(xlim,ylim,'-b')
% title('[K/Km9, Kdrug/Kdrugm9]')
% text(K./K(6),Kd./Kd(6),["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);
% 
% figure
% scatter((K-X0)./(K(6)-X0(6)),(Kd-X0d)./(Kd(6)-X0d(6)),50,'r','filled');
% hold on
% plot(xlim,ylim,'-b')
% title('[K-X0/Km9-X0m9,Kd-X0d/Kdm9-X0dm9]')
% text((K-X0)./(K(6)-X0(6)),(Kd-X0d)./(Kd(6)-X0d(6)),["CA","CBC","CDCA","DCA","LCA","m9","UDCA"]);
% 
% figure
% bar([K./K(6);Kd./K(6)]');
% hold on
% title('K/Km9 woD wD')
% somenames={'CA';'CBC';'CDCA';'DCA';'LCA';'m9';'UDCA'};
% set(gca,'xticklabel',somenames)

v = [DataDrug.CA.Xfit(end,1),DataDrug.CBC.Xfit(end,1),DataDrug.CDCA.Xfit(end,1),DataDrug.DCA.Xfit(end,1),DataDrug.LCA.Xfit(end,1),DataDrug.m9.Xfit(end,1),DataDrug.UDCA.Xfit(end,1)];
vd = [DataDrug.CAdrug.Xfit(end,1),DataDrug.CBCdrug.Xfit(end,1),DataDrug.CDCAdrug.Xfit(end,1),DataDrug.DCAdrug.Xfit(end,1),DataDrug.LCAdrug.Xfit(end,1),DataDrug.m9drug.Xfit(end,1),DataDrug.UDCAdrug.Xfit(end,1)];

figure
bar([(v-X0)./(v(6)-X0(6));(vd-X0d(6))./(v(6)-X0(6))]');
hold on
title('Xf-Xi/Xfm6-Xim6 woD wD')
somenames={'CA';'CBC';'CDCA';'DCA';'LCA';'m9';'UDCA'};
set(gca,'xticklabel',somenames)

%%


figure
bar([M./M(6);Md./M(6)]');
hold on
title('mu/mum6 woD wD')
somenames={'CA';'CBC';'CDCA';'DCA';'LCA';'m9';'UDCA'};
set(gca,'xticklabel',somenames)
xlabel('Growth rate')
set(gca,'FontSize',20)
box on

figure
bar(Dd./Dd(6));
hold on
title('kd/kdm6 wD')
somenames={'CA';'CBC';'CDCA';'DCA';'LCA';'m9';'UDCA'};
set(gca,'xticklabel',somenames)
xlabel('Antibiotic efficacy (death rate)')
set(gca,'FontSize',20)
box on

figure
bar([v./v(6);vd./v(6)]');
hold on
title('ODf/ODfm6 woD wD')
somenames={'CA';'CBC';'CDCA';'DCA';'LCA';'m9';'UDCA'};
set(gca,'xticklabel',somenames)
xlabel('Final OD')
set(gca,'FontSize',20)
box on

