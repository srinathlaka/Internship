function model = blackboxmodelDiff20(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.k = P(3);
param.tswitch = P(4);
param.kswitch = P(5);
param.q0 = P(6);
param.k2 = P(7);

%compute chisquare
model = blackboxmodel(time, param);

end