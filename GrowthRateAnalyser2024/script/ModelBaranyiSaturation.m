function Xm = ModelBaranyiSaturation(time,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parameters.x0;
q0 = parameters.q0;
k0 = parameters.k0;

%model function
Xm = x0.*((1 + q0.*exp(mu0.*time))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*time))./k0));

end
