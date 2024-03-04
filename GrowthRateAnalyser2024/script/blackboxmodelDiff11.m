function model = blackboxmodelDiff11(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.k = P(3);

%compute chisquare
model = blackboxmodel(time, param);

end