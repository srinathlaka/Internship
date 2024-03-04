function [parameters] = export(parameters,param,fittedparametersStd,p,sigmaSq,m,i)

% parameters0 = [1 klag,2 tlag*,3 q0,4 mu0,5 tswitch*,6 kswitch,7 ks--,8 t--,9 k--,10 tdeath*,11 kdeath,12 m, 13 x0*, 14 k*, 15 k2*, 16 k3*]; time in cycles


if m==1
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);

elseif m==2
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = param.q0;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = fittedparametersStd(8);
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==3
    parameters.p{i}(1) = param.klag;
    parameters.p{i}(2) = param.tlag;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = fittedparametersStd(8);
    parameters.s{i}(2) = fittedparametersStd(9);
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==4
    parameters.p{i}(1) = param.klag;
    parameters.p{i}(2) = param.tlag;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = NaN;
    parameters.p{i}(6) = NaN;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = NaN;
    parameters.p{i}(11) = NaN;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = fittedparametersStd(4);
    parameters.s{i}(2) = fittedparametersStd(5);
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = NaN;
    parameters.s{i}(6) = NaN;
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = NaN;
    parameters.s{i}(11) = NaN;
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==5
    parameters.p{i}(1) = param.klag;
    parameters.p{i}(2) = param.tlag;
    parameters.p{i}(3) = param.q0;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = NaN;
    parameters.p{i}(6) = NaN;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = NaN;
    parameters.p{i}(11) = NaN;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = fittedparametersStd(4);
    parameters.s{i}(2) = fittedparametersStd(5);
    parameters.s{i}(3) = fittedparametersStd(6);
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = NaN;
    parameters.s{i}(6) = NaN;
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = NaN;
    parameters.s{i}(11) = NaN;
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==6
    parameters.p{i}(1) = param.klag;
    parameters.p{i}(2) = param.tlag;
    parameters.p{i}(3) = param.q0;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = NaN;
    parameters.p{i}(6) = NaN;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = NaN;
    parameters.p{i}(11) = NaN;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = NaN;


    %std
    parameters.s{i}(1) = fittedparametersStd(3);
    parameters.s{i}(2) = fittedparametersStd(4);
    parameters.s{i}(3) = fittedparametersStd(5);
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = NaN;
    parameters.s{i}(6) = NaN;
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = NaN;
    parameters.s{i}(11) = NaN;
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = NaN;
elseif m==7
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = NaN;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(5);
    parameters.s{i}(6) = fittedparametersStd(6);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = fittedparametersStd(4);
    parameters.s{i}(11) = fittedparametersStd(3);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = NaN;
elseif m==8
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = param.k2;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = fittedparametersStd(8);
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==9
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = param.kswitch2;
    parameters.p{i}(8) = param.tswitch2;
    parameters.p{i}(9) = param.k2;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = fittedparametersStd(9);
    parameters.s{i}(8) = fittedparametersStd(10);
    parameters.s{i}(9) = fittedparametersStd(8);
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==10
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = param.kswitch2;
    parameters.p{i}(8) = param.tswitch2;
    parameters.p{i}(9) = param.k2;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(5);
    parameters.s{i}(6) = fittedparametersStd(6);
    parameters.s{i}(7) = fittedparametersStd(7);
    parameters.s{i}(8) = fittedparametersStd(8);
    parameters.s{i}(9) = fittedparametersStd(10);
    parameters.s{i}(10) = fittedparametersStd(4);
    parameters.s{i}(11) = fittedparametersStd(3);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(9);
elseif m==11
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = NaN;
    parameters.p{i}(6) = NaN;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = NaN;
    parameters.p{i}(11) = NaN;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = NaN;
    parameters.s{i}(6) = NaN;
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = NaN;
    parameters.s{i}(11) = NaN;
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==12
    parameters.p{i}(1) = param.klag;
    parameters.p{i}(2) = time(tfin);
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.klag;
    parameters.p{i}(5) = NaN;
    parameters.p{i}(6) = NaN;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = NaN;
    parameters.p{i}(11) = NaN;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = NaN;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(2);
    parameters.s{i}(5) = NaN;
    parameters.s{i}(6) = NaN;
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = NaN;
    parameters.s{i}(11) = NaN;
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(1);
    parameters.s{i}(14) = NaN;
elseif m==13
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = param.q0;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = NaN;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = fittedparametersStd(7);
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(5);
    parameters.s{i}(6) = fittedparametersStd(6);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = fittedparametersStd(4);
    parameters.s{i}(11) = fittedparametersStd(3);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = NaN;
elseif m==14
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = param.q0;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = NaN;
    parameters.p{i}(6) = NaN;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = NaN;
    parameters.p{i}(11) = NaN;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = fittedparametersStd(4);
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = NaN;
    parameters.s{i}(6) = NaN;
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = NaN;
    parameters.s{i}(11) = NaN;
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
elseif m==15
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = NaN;
    parameters.p{i}(8) = NaN;
    parameters.p{i}(9) = NaN;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;
    parameters.p{i}(15) = param.k2;
    parameters.p{i}(16) = param.k3;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = NaN;
    parameters.s{i}(8) = NaN;
    parameters.s{i}(9) = NaN;
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
    parameters.s{i}(15) = fittedparametersStd(8);
    parameters.s{i}(16) = fittedparametersStd(9);
elseif m==16
    parameters.p{i}(1) = NaN;
    parameters.p{i}(2) = NaN;
    parameters.p{i}(3) = NaN;
    parameters.p{i}(4) = param.mu;
    parameters.p{i}(5) = param.tswitch;
    parameters.p{i}(6) = param.kswitch;
    parameters.p{i}(7) = param.kswitch2;
    parameters.p{i}(8) = param.tswitch2;
    parameters.p{i}(9) = param.k2;
    parameters.p{i}(10) = param.tdeath;
    parameters.p{i}(11) = param.kdeath;
    parameters.p{i}(12) = NaN;
    parameters.p{i}(13) = param.x0;
    parameters.p{i}(14) = param.k;

    %std
    parameters.s{i}(1) = NaN;
    parameters.s{i}(2) = NaN;
    parameters.s{i}(3) = NaN;
    parameters.s{i}(4) = fittedparametersStd(1);
    parameters.s{i}(5) = fittedparametersStd(6);
    parameters.s{i}(6) = fittedparametersStd(7);
    parameters.s{i}(7) = fittedparametersStd(9);
    parameters.s{i}(8) = fittedparametersStd(10);
    parameters.s{i}(9) = fittedparametersStd(8);
    parameters.s{i}(10) = fittedparametersStd(5);
    parameters.s{i}(11) = fittedparametersStd(4);
    parameters.s{i}(12) = NaN;
    parameters.s{i}(13) = fittedparametersStd(2);
    parameters.s{i}(14) = fittedparametersStd(3);
end


parameters.pval{i}(1) = p;
parameters.residualDOF{i}(1) = sigmaSq;





end
