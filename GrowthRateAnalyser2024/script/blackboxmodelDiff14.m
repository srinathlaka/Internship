function model = blackboxmodelDiff14(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.k = P(3);
param.q0 = P(4);

%compute chisquare
model = blackboxmodel(time, param);

end