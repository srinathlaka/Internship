function chisquareData = minimizeChiSquareSaturationDDecline(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu0 = P(1);
parameters.x0 = P(2);
parameters.q0 = P(3);
parameters.k0 = P(4);
parameters.g = P(5);
parameters.d0 = P(6);
parameters.tdeath = P(7);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end