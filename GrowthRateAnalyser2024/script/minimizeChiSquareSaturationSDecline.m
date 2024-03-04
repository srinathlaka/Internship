function chisquareData = minimizeChiSquareSaturationSDecline(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.x0 = P(1);
parameters.k0 = P(2);
parameters.g = P(3);
parameters.d0 = P(4);
parameters.tdeath = P(5);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end