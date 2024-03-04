function chisquareData = minimizeChiSquareSD(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.k = P(3);
parameters.kdeath = P(4);
parameters.tdeath = P(5);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end