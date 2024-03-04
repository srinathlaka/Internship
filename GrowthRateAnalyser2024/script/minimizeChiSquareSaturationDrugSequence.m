function chisquareData = minimizeChiSquareSaturationDrugSequence(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.x0 = P(1);
parameters.k0 = P(2);
parameters.d0 = P(3);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end