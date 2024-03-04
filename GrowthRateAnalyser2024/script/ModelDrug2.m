function Xm = ModelDrug2(time,parametersD,parameters)

%recover the parameters if needed
d0 = parametersD.d0;
x0 = parametersD.x0;
%q0 = parameters.q0;
mu0 = parameters.mu0;

%model function
Xm = x0.*exp((mu0-d0).*time);

end
