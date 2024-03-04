function chisquareData = minimizeChiSquareBkg1(P0,blackboxmodel0,time,parameters0,Data0)

%clean parameters to estimate
parameters0.a0 = P0(1);
parameters0.k0 = P0(2);
parameters0.b0 = P0(3);

%compute chisquare
chisquareData = fitModel(blackboxmodel0,time,parameters0,Data0,0,0);

end