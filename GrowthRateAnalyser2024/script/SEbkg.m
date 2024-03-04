function SEy = SEbkg(U,time,blackboxmodel,fittedparameters,sigmaSq,m)

Cov = inv(U);
SEy = zeros (size(time,1),1);

for i = 1:size(time,1)
x = time(i);

if m==1
f = @(P0) blackboxmodelBkgStd1(P0,blackboxmodel,x);
elseif m==2
f = @(P0) blackboxmodelBkgStd2(P0,blackboxmodel,x);
elseif m==3
f = @(P0) blackboxmodelBkgStd3(P0,blackboxmodel,x);
end


P0 = fittedparameters;
G = cgradient(f,P0);
SEy(i) = real(sqrt(abs(G'*Cov*G + sigmaSq)));

end


end