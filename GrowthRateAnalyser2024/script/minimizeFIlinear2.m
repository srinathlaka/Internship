function chisquareData = minimizeFIlinear2(P,blackboxmodel,time,parameters,Data)

%clean parameters to estimate
parameters.p(1) = P(1);
parameters.p(2) = P(2);
parameters.p(3) = P(3);
parameters.p(4) = P(4);

%compute chisquare
chisquareData = fitModel(blackboxmodel,time,parameters,Data,1,0);

end