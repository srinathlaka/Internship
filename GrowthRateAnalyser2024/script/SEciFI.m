function SEy = SEciFI(U,time,blackboxmodel,fittedparameters,sigmaSq,m,confidenceprediction)

Cov = inv(U);
SEy = zeros (size(time,1),1);

for i = 1:size(time,1)
    x = time(i);

    if m==1
        f = @(P0) blackboxmodelFI1(P0,blackboxmodel,x);
    elseif m==2
        f = @(P0) blackboxmodelFI2(P0,blackboxmodel,x);
    elseif m==3
        f = @(P0) blackboxmodelFI3(P0,blackboxmodel,x);
    end


    P0 = fittedparameters;
    G = cgradient(f,P0);
    if confidenceprediction==0
        SEy(i) = real(sqrt(abs(G'*Cov*G + sigmaSq))); %1-alpha confidence interval of the fit
    elseif confidenceprediction==1
        SEy(i) = real(sqrt(abs(G'*Cov*G))); %prediction of finding new data in 95% interval
    end
end


end