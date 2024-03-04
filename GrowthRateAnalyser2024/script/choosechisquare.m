function modelChi = choosechisquare(m,blackboxmodel,time,param,Data)

if m==1
     modelChi = @(P) minimizeChiSquareSD3(P,blackboxmodel,time,param,Data);
elseif m==2
    modelChi = @(P) minimizeChiSquareLSD3(P,blackboxmodel,time,param,Data);
elseif m==3
    modelChi = @(P) minimizeChiSquareLexpSD3(P,blackboxmodel,time,param,Data);
elseif m==4
    modelChi = @(P) minimizeChiSquareLlinearS(P,blackboxmodel,time,param,Data);
elseif m==5
    modelChi = @(P) minimizeChiSquareLlinearLS(P,blackboxmodel,time,param,Data);
elseif m==6
    modelChi = @(P) minimizeChiSquareLlinearLexp(P,blackboxmodel,time,param,Data);
elseif m==7
    modelChi = @(P) minimizeChiSquareSD2(P,blackboxmodel,time,param,Data);
elseif m==8
    modelChi = @(P) minimizeChiSquareSD4(P,blackboxmodel,time,param,Data);
elseif m==9
    modelChi = @(P) minimizeChiSquareSD5(P,blackboxmodel,time,param,Data);
elseif m==10
    modelChi = @(P) minimizeChiSquareSD10(P,blackboxmodel,time,param,Data);
elseif m==11
    modelChi = @(P) minimizeChiSquareES(P,blackboxmodel,time,param,Data);
elseif m==12
    modelChi = @(P) minimizeChiSquareLinear(P,blackboxmodel,time,param,Data);
elseif m==13
    modelChi = @(P) minimizeChiSquareLSD3a(P,blackboxmodel,time,param,Data);
elseif m==14
    modelChi = @(P) minimizeChiSquareLSD3b(P,blackboxmodel,time,param,Data);
elseif m==15
    modelChi = @(P) minimizeChiSquarek3(P,blackboxmodel,time,param,Data);
elseif m==16
    modelChi = @(P) minimizeChiSquareSD5(P,blackboxmodel,time,param,Data);
end



end