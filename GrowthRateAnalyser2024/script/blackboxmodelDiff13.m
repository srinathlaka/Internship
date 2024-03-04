function model = blackboxmodelDiff13(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.kdeath = P(3);
param.tdeath = P(4);
param.tswitch = P(5);
param.kswitch = P(6);
param.q0 = P(7);

%compute chisquare
model = blackboxmodel(time, param);

end