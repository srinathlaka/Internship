function model = blackboxmodelDiff18(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.klag = P(3);
param.tdeath = P(4);
param.tswitch = P(5);
param.kdeath = P(6);
param.kswitch = P(7);
param.tswitch2 = P(8);

%compute chisquare
model = blackboxmodel(time, param);

end