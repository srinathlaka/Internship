function model = blackboxmodelDiff12(P,blackboxmodel,time)

%clean parameters to estimate
param = struct();

param.x0 = P(1);
param.klag = P(2);

%compute chisquare
model = blackboxmodel(time, param);

end