function model = blackboxmodelDiff6(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.klag = P(3);
param.tlag = P(4);
param.q0 = P(5);

%compute chisquare
model = blackboxmodel(time, param);

end