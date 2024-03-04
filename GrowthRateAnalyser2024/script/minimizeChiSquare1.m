function chisquareData = minimizeChiSquare1(P0,blackboxmodel0,time,parameters0,Data0)

%clean parameters to estimate
parameters0.q0 = P0(1);

%compute chisquare
chisquareData = fitModel(blackboxmodel0,time,parameters0,Data0,0,0);

end