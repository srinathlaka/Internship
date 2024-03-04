function Xm = ModelLEES(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
klag = parameters.klag;
kswitch = parameters.kswitch;
k = parameters.k;

Tt = parameters.tdeath;
Tdeath = Tt.*ones(size(time,1),size(time,2));

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

%model function

Xm = ((klag.*time)+x0).*heaviside(Tswitch-time)+...
    ((klag.*Tswitch)+x0).*(exp(mu.*(time-Tswitch))).*heaviside(Tdeath-time).*heaviside(time-Tswitch)+...
    ((((((klag.*Tswitch)+x0).*(exp(mu.*(Tdeath-Tswitch))))).*(exp(kswitch.*(time-Tdeath)))./(1+(((((klag.*Tswitch)+x0).*(exp(mu.*(Tdeath-Tswitch)))))./k).*(exp(kswitch.*(time-Tdeath))-1)))).*heaviside(time-Tdeath);


end
