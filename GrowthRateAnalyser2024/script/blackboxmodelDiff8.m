function model = blackboxmodelDiff8(P,blackboxmodel,time)

%clean parameters to estimate
parameters = struct();
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.k = P(3);
parameters.kdeath = P(4);
parameters.tdeath = P(5);
parameters.tswitch = P(6);
parameters.kswitch = P(7);
parameters.k2 = P(8);

%compute chisquare
model = blackboxmodel(time, parameters);

end