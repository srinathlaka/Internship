function chisquareData = minimizeChiSquareLagExp(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.q0 = P(3);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end