function model = blackboxmodelDiff3(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.k = P(3);
param.kdeath = P(4);
param.tdeath = P(5);
param.tswitch = P(6);
param.kswitch = P(7);
param.klag = P(8);
param.tlag = P(9);

%compute chisquare
model = blackboxmodel(time, param);

end