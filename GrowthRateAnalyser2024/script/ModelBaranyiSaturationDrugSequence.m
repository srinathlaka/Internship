function Xm = ModelBaranyiSaturationDrugSequence(time,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parameters.x0;
q0 = parameters.q0;
k0 = parameters.k0;
d0 = parameters.d0;

tdrugT = parameters.tdrug;
tdrug = tdrugT.*ones(size(time,1),size(time,2));

%model function
%Xm = (x0.*((1 + q0.*exp((mu0-d0.*(ThetaFunction(time,tdrug))).*time))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0-d0.*(ThetaFunction(time,tdrug)).*time))./k0)));
Xm = ((x0.*((1 + q0.*exp(mu0.*time))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*time))./k0)))).*(exp((-d0.*(heaviside(time-tdrug))).*time));
%Xm = ((x0.*((1 + q0.*exp(mu0.*time))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*time))./k0)))).*heaviside(tdrug-time) +  ((x0.*((1 + q0.*exp(mu0.*tdrug))./(1 + q0 - q0.*x0./k0 + (q0.*x0.*exp(mu0.*tdrug))./k0)))).*(exp(-d0.*time)).*heaviside(time-tdrug);

end



