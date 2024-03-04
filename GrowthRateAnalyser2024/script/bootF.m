function fittedparameters = bootF(param,Data,bootr,blackboxmodel,time,P0,lb,ub,options,m)

param.Chistd = 0;
Data.X = Data.Xfit + bootr;

if m==1
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD3(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==2
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLSD3(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==3
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLexpSD3(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==4
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLlinearS(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==5
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLlinearLS(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==6
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLlinearLexp(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==7
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD2(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==8
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD4(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==9
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD5(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==10
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD10(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==11
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareES(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==12
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLinear(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==13
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLSD3a(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==14
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareLSD3b(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==15
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquarek3(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
elseif m==16
    [fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD5(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
end


end