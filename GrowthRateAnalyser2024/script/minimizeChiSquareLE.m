function chisquareData = minimizeChiSquareLE(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.mu = P(1);
parameters.x0 = P(2);
parameters.klag = P(3);
parameters.tswitch = P(4);


%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end