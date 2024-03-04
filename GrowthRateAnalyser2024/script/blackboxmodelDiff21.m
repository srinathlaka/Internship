function model = blackboxmodelDiff21(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.mu = P(1);
param.x0 = P(2);
param.klag = P(3);
param.tswitch = P(4);

%compute chisquare
model = blackboxmodel(time, param);

end