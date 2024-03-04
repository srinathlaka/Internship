function Xm = ModelSaturationSwitchSaturationExpDeath(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
k = parameters.k;
k2 = parameters.k2;
kdeath = parameters.kdeath;
kswitch2 = parameters.kswitch2;
kswitch = parameters.kswitch;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

Ts2 = parameters.tswitch2;
Tswitch2 = Ts2.*ones(size(time,1),size(time,2));

%model function

% Xm = (x0.*(exp(mu.*time))./(1+(x0./k).*(exp(mu.*time)-1))).*heaviside(Tswitch-time)+...
% (((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(time-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(time-Tswitch))-1))).*heaviside(time-Tswitch).*heaviside(Tswitch2-time)+...
% (((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(Tswitch2-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(Tswitch2-Tswitch))-1))).*heaviside(time-Tswitch2).*heaviside(Tdeath-time).*(exp(kswitch2.*(time-Tswitch2)))+...
% ((((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(Tswitch2-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(Tswitch2-Tswitch))-1))).*(exp(kswitch2.*(Tdeath-Tswitch2)))).*heaviside(time-Tdeath).*(exp(-kdeath.*(time-Tdeath)));

Xm = (x0.*(exp(mu.*time))./(1+(x0./k).*(exp(mu.*time)-1))).*heaviside(Tswitch-time)+...
(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(time-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(time-Tswitch))-1))).*heaviside(time-Tswitch).*heaviside(Tswitch2-time)+...
(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(Tswitch2-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(Tswitch2-Tswitch))-1))).*heaviside(time-Tswitch2).*heaviside(Tdeath-time).*(exp(kswitch2.*(time-Tswitch2)))+...
((((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1)))).*(exp(kswitch.*(Tswitch2-Tswitch)))./(1+(((x0.*(exp(mu.*Tswitch))./(1+(x0./k).*(exp(mu.*Tswitch)-1))))./k2).*(exp(kswitch.*(Tswitch2-Tswitch))-1))).*(exp(kswitch2.*(Tdeath-Tswitch2)))).*heaviside(time-Tdeath).*(exp(-kdeath.*(time-Tdeath)));


end
