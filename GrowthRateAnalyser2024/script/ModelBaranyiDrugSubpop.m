function Xm = ModelBaranyiDrugSubpop(time,parametersD,parameters)

%recover the parameters if needed
d0 = parametersD.d0;
f0 = parametersD.f0;
q01 = parametersD.q01;
mu01 = parametersD.mu01;
d01 = parametersD.d01;

x0 = parameters.x0;
q0 = parameters.q0;
mu0 = parameters.mu0;

%model function
Xm = (f0).*x0.*(1+q0.*exp((mu0-d0).*time))./(1+q0) + (1-f0).*x0.*(1+q01.*exp((mu01-d01).*time))./(1+q01);

end
