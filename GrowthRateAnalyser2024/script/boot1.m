function fittedparameters = boot1(param,Data,bootr,blackboxmodel,time,P0,lb,ub,options)

param.Chistd = 0;
Data.X = Data.Xfit + bootr;
[fittedparameters,~] = fminsearchbnd(@(P) minimizeChiSquareSD3(P,blackboxmodel,time,param,Data),P0,lb,ub,options);

end