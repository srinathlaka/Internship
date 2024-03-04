function chisquareData = minimizeChiSquareLESES(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.k = P(3);
parameters.tswitch = P(4);
parameters.kswitch = P(5);
parameters.q0 = P(6);
parameters.k2 = P(7);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end