function Xm = ModelLagLinearLagSaturation(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
klag = parameters.klag;
k = parameters.k;
q0 = parameters.q0;

Tl = parameters.tlag;
Tlag = Tl.*ones(size(time,1),size(time,2));

%model function


Xm = ((klag.*time)+x0).*heaviside(Tlag-time)+...
    (((klag.*Tlag)+x0).*(1 + q0.*exp(mu.*(time-Tlag)))./(1 + q0 - q0.*((klag.*Tlag)+x0)./k + (q0.*((klag.*Tlag)+x0).*exp(mu.*(time-Tlag)))./k)).*heaviside(time-Tlag);


end
