function Xm = ModelBaranyiSaturationDrugDecline(time,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parameters.x0;
q0 = parameters.q0;
k0 = parameters.k0;
g = parameters.g;
d0 = parameters.d0;

Tt = parameters.tdeath;
T = Tt.*ones(size(time,1),size(time,2));
tdrug = parameters.tdrug;

%model function
%Xm = x0.*(f.*((1 + q0.*exp(mu0.*time))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*time))./k0)) + (1-f).*(exp(-g.*time)));
Xm = (x0.*( ((1 + q0.*exp(mu0.*time))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*time))./k0)).*heaviside(T-time) + (((1 + q0.*exp(mu0.*T))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*T))./k0))).*heaviside(time-T).*(exp(-g.*(time-T))))).*(exp((-d0.*(heaviside(time-tdrug))).*time));

end
