function model = blackboxmodelDiff22(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);

%compute chisquare
model = blackboxmodel(time, param);

end