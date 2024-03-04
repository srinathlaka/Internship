function Xm = ModelLESES(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
q0 = parameters.q0;
k = parameters.k;
kswitch = parameters.kswitch;
k2 = parameters.k2;

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

%model function

Xm = (x0.*(1 + q0.*exp(mu.*time))./(1 + q0 - q0.*x0./k + (q0.*x0.*exp(mu.*time))./k)).*heaviside(Tswitch-time)+...
        (((x0.*(1 + q0.*exp(mu.*Tswitch))./(1 + q0 - q0.*x0./k + (q0.*x0.*exp(mu.*Tswitch))./k))).*(exp(kswitch.*(time-Tswitch)))./(1+(((x0.*(1 + q0.*exp(mu.*Tswitch))./(1 + q0 - q0.*x0./k + (q0.*x0.*exp(mu.*Tswitch))./k)))./k2).*(exp(kswitch.*(time-Tswitch))-1))).*heaviside(time-Tswitch);


end
