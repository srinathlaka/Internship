function chisquareData = minimizeChiSquareDrugSubpopDouble(P,blackboxmodel,time,parametersD,Data,parameters)

%clean parameters to estimate
parametersD.d0 = P(1);
parametersD.f0 = P(2);
parametersD.q01 = P(3);
parametersD.mu01 = P(4);
parametersD.d01 = P(5);
parametersD.q0 = P(6);
parametersD.mu0 = P(7);

%compute chisquare
chisquareData = fitModelDrug(blackboxmodel,time,parametersD,Data,1,parameters);

end