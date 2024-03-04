function Xm = ModelLEED(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
klag = parameters.klag;
kdeath = parameters.kdeath;
kswitch = parameters.kswitch;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

Ts2 = parameters.tswitch2;
Tswitch2 = Ts2.*ones(size(time,1),size(time,2));

%model function

Xm = ((klag.*time)+x0).*heaviside(Tswitch-time)+...
    ((klag.*Tswitch)+x0).*(exp(mu.*(time-Tswitch))).*heaviside(Tswitch2-time).*heaviside(time-Tswitch)+...
    (((klag.*Tswitch)+x0).*(exp(mu.*(Tswitch2-Tswitch))).*(exp(kswitch.*(time-Tswitch2)))).*heaviside(Tdeath-time).*heaviside(time-Tswitch2)+...
    ((((klag.*Tswitch)+x0).*(exp(mu.*(Tswitch2-Tswitch))).*(exp(kswitch.*(Tdeath-Tswitch2)))).*(exp(kdeath.*(time-Tdeath)))).*heaviside(time-Tdeath);


end
