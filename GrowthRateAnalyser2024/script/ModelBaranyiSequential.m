function Xm = ModelBaranyiSequential(time,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parameters.x0;
q0 = parameters.q0;
d0 = parameters.d0;
tdrug = parameters.tdrug;

%model function
Xm = (x0*(1+q0*exp(mu0*time))/(1+q0)).*ThetaFunction(tdrug,time) + ((x0.*(1+q0*exp(mu0.*tdrug))/(1+q0)).*exp((mu0-d0).*(time-tdrug))).*ThetaFunction(time,tdrug);

end
