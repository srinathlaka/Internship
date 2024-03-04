function chisquareData = minimizeChiSquareMonodODE(P,blackboxmodel,time,Data,parameters)

%clean parameters to estimate
parameters.mu0 = P(1);
parameters.k0 = P(2);
parameters.y0 = P(3);

%compute chisquare
chisquareData = fitModelMonodODE(blackboxmodel,time,Data,1,parameters);

end