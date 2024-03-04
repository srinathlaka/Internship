function Xm = ModelLagLinearSaturationSwitchDeath(time,parameters)

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


Xm = ((klag.*time)+x0).*heaviside(Tlag-time)+...
(((klag.*Tlag)+x0).*(exp(mu.*(time-Tlag)))./(1+(((klag.*Tlag)+x0)./k).*(exp(mu.*(time-Tlag))-1))).*heaviside(Tswitch-time).*heaviside(time-Tlag)+...
(((klag.*Tlag)+x0).*(exp(mu.*(Tswitch-Tlag)))./(1+(((klag.*Tlag)+x0)./k).*(exp(mu.*(Tswitch-Tlag))-1))).*exp(kswitch.*(time-Tswitch)).*heaviside(time-Tswitch).*heaviside(Tdeath-time)+...
(((klag.*Tlag)+x0).*(exp(mu.*(Tswitch-Tlag)))./(1+(((klag.*Tlag)+x0)./k).*(exp(mu.*(Tswitch-Tlag))-1))).*exp(kswitch.*(Tdeath-Tswitch)).*(exp(-kdeath.*(time-Tdeath))).*heaviside(time-Tdeath);


end
