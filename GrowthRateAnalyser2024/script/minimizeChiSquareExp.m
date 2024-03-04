function chisquareData = minimizeChiSquareExp(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu0 = P(1);
parameters.x0 = P(2);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end