function Xm = ModelExpSwitchDeath(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
kdeath = parameters.kdeath;
kswitch = parameters.kswitch;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

%model function

Xm = x0.*(exp(mu.*time)).*heaviside(Tswitch-time)+...
    x0.*(exp(mu.*Tswitch)).*heaviside(time-Tswitch).*heaviside(Tdeath-time).*exp(kswitch.*(time-Tswitch))+...
    x0.*(exp(mu.*Tswitch)).*exp(kswitch.*(Tdeath-Tswitch)).*heaviside(time-Tdeath).*(exp(-kdeath.*(time-Tdeath)));

% Xm = x0.*(exp(mu.*time)).*heaviside(Tswitch-time)+...
%     x0.*(exp(mu.*Tswitch)).*heaviside(time-Tswitch).*heaviside(Tdeath-time).*exp(kswitch.*(time-Tswitch))+...
%     x0.*(exp(mu.*Tswitch)).*exp(kswitch.*(Tdeath-Tswitch)).*heaviside(time-Tdeath).*(exp(-kdeath.*(time-Tdeath)));

end
