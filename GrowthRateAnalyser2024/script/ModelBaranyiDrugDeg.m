function Xm = ModelBaranyiDrugDeg(time,parametersD,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parametersD.x0;
%q0 = parameters.q0;
d0 = parameters.d0;

ec0 = parameters.ec0;
n0 = parameters.n0;
di0 = parameters.di0;
em0 = parameters.em0;

%tdrug = parameters.tdrug;

%model function
Xm = x0.*exp(mu0.*(time)).*((ec0.^n0 + (di0.^n0).*exp(-d0.*n0.*(time)))./(ec0.^n0 + di0.^n0)).^(em0./(n0.*d0));

end
