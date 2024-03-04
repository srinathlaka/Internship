function Xm = ModelLagTime(time,parameters0)

%recover the parameters if needed
mu0 = parameters0.mu0;
IC50 = parameters0.IC50;
q0 = parameters0.q0;

%model function
Xm = (log(1./q0)./(mu0./(1+time/IC50)));

end
