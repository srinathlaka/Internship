function Xm = ModelSaturationExpDeath(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
q0 = parameters.q0;
k = parameters.k;
kdeath = parameters.kdeath;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

%model function
Xm = ((x0.*exp(mu.*time))./(1+(x0./k).*(mu./(mu-q0)).*(exp((mu-q0).*time)-1))).*heaviside(Tdeath-time)+...
    ((((x0.*exp(mu.*Tdeath))./(1+(x0./k).*(mu./(mu-q0)).*(exp((mu-q0).*Tdeath)-1))).*heaviside(time-Tdeath)).*(exp(-kdeath.*(time-Tdeath))));

end
