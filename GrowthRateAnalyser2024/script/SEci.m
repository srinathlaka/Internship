function SEy = SEci(U,time,blackboxmodel,fittedparameters,sigmaSq,m,confidenceprediction)

Cov = inv(U);
SEy = zeros (size(time,1),1);
%SEp = zeros (size(time,1),1);

for i = 1:size(time,1)
    x = time(i);

    if m==1
        f = @(P0) blackboxmodelDiff1(P0,blackboxmodel,x);
    elseif m==2
        f = @(P0) blackboxmodelDiff2(P0,blackboxmodel,x);
    elseif m==3
        f = @(P0) blackboxmodelDiff3(P0,blackboxmodel,x);
    elseif m==4
        f = @(P0) blackboxmodelDiff4(P0,blackboxmodel,x);
    elseif m==5
        f = @(P0) blackboxmodelDiff5(P0,blackboxmodel,x);
    elseif m==6
        f = @(P0) blackboxmodelDiff6(P0,blackboxmodel,x);
    elseif m==7
        f = @(P0) blackboxmodelDiff7(P0,blackboxmodel,x);
    elseif m==8
        f = @(P0) blackboxmodelDiff8(P0,blackboxmodel,x);
    elseif m==9
        f = @(P0) blackboxmodelDiff9(P0,blackboxmodel,x);
    elseif m==10
        f = @(P0) blackboxmodelDiff10(P0,blackboxmodel,x);
    elseif m==11
        f = @(P0) blackboxmodelDiff11(P0,blackboxmodel,x);
    elseif m==12
        f = @(P0) blackboxmodelDiff12(P0,blackboxmodel,x);
    elseif m==13
        f = @(P0) blackboxmodelDiff13(P0,blackboxmodel,x);
    elseif m==14
        f = @(P0) blackboxmodelDiff14(P0,blackboxmodel,x);
    elseif m==15
        f = @(P0) blackboxmodelDiff15(P0,blackboxmodel,x);
    elseif m==16
        f = @(P0) blackboxmodelDiff16(P0,blackboxmodel,x);
    elseif m==17
        f = @(P0) blackboxmodelDiff17(P0,blackboxmodel,x);
    elseif m==18
        f = @(P0) blackboxmodelDiff18(P0,blackboxmodel,x);
    elseif m==19
        f = @(P0) blackboxmodelDiff19(P0,blackboxmodel,x);
    elseif m==20
        f = @(P0) blackboxmodelDiff20(P0,blackboxmodel,x);
    elseif m==21
        f = @(P0) blackboxmodelDiff21(P0,blackboxmodel,x);
    elseif m==22
        f = @(P0) blackboxmodelDiff22(P0,blackboxmodel,x);
    elseif m==23
        f = @(P0) blackboxmodelDiff23(P0,blackboxmodel,x);
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