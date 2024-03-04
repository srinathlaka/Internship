function model = blackboxmodelFI3(P,blackboxmodel,time)

%clean parameters to estimate
parameters.p(1) = P(1);
parameters.p(2) = P(2);
parameters.p(3) = P(3);
parameters.p(4) = P(4);
parameters.p(5) = P(5);
parameters.p(6) = P(6);
parameters.p(7) = P(7);

%compute model
model = blackboxmodel(time, parameters);

end