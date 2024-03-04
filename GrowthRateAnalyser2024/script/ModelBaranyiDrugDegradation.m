function Xm = ModelBaranyiDrugDegradation(time,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parameters.x0;
q0 = parameters.q0;
d0 = parameters.d0;

ec0 = parameters.ec0;
n0 = parameters.n0;
di0 = parameters.di0;
em0 = parameters.em0;

tdrug = parameters.tdrug;

%model function
Xm = (x0*(1+q0*exp(mu0*time))/(1+q0)).*ThetaFunction(tdrug,time) + ((x0.*(1+q0.*exp(mu0.*tdrug))/(1+q0)).*exp(mu0.*(time-tdrug))).*ThetaFunction(time,tdrug).*((ec0.^n0 + (di0.^n0).*exp(-d0.*n0.*(time-tdrug)))./(ec0.^n0 + di0.^n0)).^(em0./(n0.*d0));

end
