function Xm = ModelLagSaturationDeath(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
q0 = parameters.q0;
k = parameters.k;
kdeath = parameters.kdeath;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

%model function
Xm = x0.*( ((1 + q0.*exp(mu.*time))./(1 + q0 - q0.*x0./k + (q0.*x0.*exp(mu.*time))./k)).*heaviside(Tdeath-time) +...
    (((1 + q0.*exp(mu.*Tdeath))./(1 + q0 - q0.*x0./k + (q0.*x0.*exp(mu.*Tdeath))./k))).*heaviside(time-Tdeath).*(exp(-kdeath.*(time-Tdeath))));

end
