function chisquareData = minimizeChiSquareSD6(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.kdeath = P(3);
parameters.tdeath = P(4);
parameters.tswitch = P(5);
parameters.kswitch = P(6);
parameters.kswitch2 = P(7);
parameters.tswitch2 = P(8);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end