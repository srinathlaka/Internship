function chisquareData = minimizeChiSquareLinear(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.x0 = P(1);
parameters.klag = P(2);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end