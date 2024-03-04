function Xm = ModelLagExpSaturationSwitchDeath(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
klag = parameters.klag;
k = parameters.k;
kdeath = parameters.kdeath;
kswitch = parameters.kswitch;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

Tl = parameters.tlag;
Tlag = Tl.*ones(size(time,1),size(time,2));

%model function


Xm = x0.*(exp(klag.*time)).*heaviside(Tlag-time)+...
(x0.*(exp(klag.*Tlag)).*(exp(mu.*(time-Tlag)))./(1+((x0.*(exp(klag.*Tlag)))./k).*(exp(mu.*(time-Tlag))-1))).*heaviside(Tswitch-time).*heaviside(time-Tlag)+...
(x0.*(exp(klag.*Tlag)).*(exp(mu.*(Tswitch-Tlag)))./(1+((x0.*(exp(klag.*Tlag)))./k).*(exp(mu.*(Tswitch-Tlag))-1))).*exp(kswitch.*(time-Tswitch)).*heaviside(time-Tswitch).*heaviside(Tdeath-time)+...
(x0.*(exp(klag.*Tlag)).*(exp(mu.*(Tswitch-Tlag)))./(1+((x0.*(exp(klag.*Tlag)))./k).*(exp(mu.*(Tswitch-Tlag))-1))).*exp(kswitch.*(Tdeath-Tswitch)).*(exp(-kdeath.*(time-Tdeath))).*heaviside(time-Tdeath);


end
