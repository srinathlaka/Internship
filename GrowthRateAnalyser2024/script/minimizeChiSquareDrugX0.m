function chisquareData = minimizeChiSquareDrugX0(P,blackboxmodel,time,parametersD,Data,parameters)

%clean parameters to estimate
parametersD.d0 = P(1);
parametersD.x0 = P(2);

%compute chisquare
chisquareData = fitModelDrug(blackboxmodel,time,parametersD,Data,1,parameters);

end