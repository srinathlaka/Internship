function model = blackboxmodelDiff5(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.k = P(3);
param.klag = P(4);
param.tlag = P(5);
param.q0 = P(6);

%compute chisquare
model = blackboxmodel(time, param);

end