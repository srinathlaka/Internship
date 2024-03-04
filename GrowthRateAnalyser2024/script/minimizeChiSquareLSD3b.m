function chisquareData = minimizeChiSquareLSD3b(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.k = P(3);
parameters.q0 = P(4);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end