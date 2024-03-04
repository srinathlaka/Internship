function model = blackboxmodelBkgStd3(P,blackboxmodel,time)

%clean parameters to estimate
bkg = struct();

bkg.a0 = P(1);
bkg.n = P(2);
bkg.b0 = P(3);

%compute chisquare
model = blackboxmodel(time, bkg);

end