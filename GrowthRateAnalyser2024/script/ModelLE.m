function Xm = ModelLE(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
klag = parameters.klag;

Ts = parameters.tswitch;
Tswitch = Ts.*ones(size(time,1),size(time,2));

%model function

Xm = ((klag.*time)+x0).*heaviside(Tswitch-time)+...
    ((klag.*Tswitch)+x0).*(exp(mu.*(time-Tswitch))).*heaviside(time-Tswitch);

% Xm = ((klag.*time)+x0).*heaviside(Tswitch-time)+...
%     ((klag.*Tswitch)+x0).*(exp(mu.*(time))).*heaviside(time-Tswitch);

end
