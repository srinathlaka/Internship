function chisquareData = minimizeChiSquareDrugODE(P,blackboxmodel,time,parametersD,Data,parameters)

%clean parameters to estimate
parametersD.d0 = P(1);

%compute chisquare
chisquareData = fitModelDrugODE(blackboxmodel,time,parametersD,Data,1,parameters);

end