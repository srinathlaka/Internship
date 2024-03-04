function Xm = ModelSaturationSwitchSaturationDeath(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
k = parameters.k;
k2 = parameters.k2;
kdeath = parameters.kdeath;
kswitch = parameters.kswitch;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

%model function

Xm = (x0.*(exp(mu.*time))./(1+(x0./k).*(exp(mu.*time)-1))).*heaviside(Tswitch-time)+...
(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(time-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(time-Tswitch))-1))).*heaviside(time-Tswitch).*heaviside(Tdeath-time)+...
(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(Tdeath-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(Tdeath-Tswitch))-1))).*heaviside(time-Tdeath).*(exp(-kdeath.*(time-Tdeath)));



end
