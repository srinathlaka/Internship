function chisquareData = minimizeChiSquareLEES(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.klag = P(3);
parameters.kswitch = P(4);
parameters.tdeath = P(5);
parameters.tswitch = P(6);
parameters.k = P(7);


%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end