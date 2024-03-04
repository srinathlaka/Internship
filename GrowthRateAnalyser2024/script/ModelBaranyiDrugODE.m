function [dx] = ModelBaranyiDrugODE(t,x,parametersD,parameters)

%recover the parameters if needed
d0 = parametersD.d0;
q0 = parameters.q0;
mu0 = parameters.mu0;

%define the variables
X1 = x(1);

%ODE
dX1 = ((q0.*exp((mu0-d0).*t))./(1+q0.*exp((mu0-d0).*t))).*(mu0-d0).*X1; %the drug affects all the growth
%dX1 = ((q0.*exp((mu0).*t))./(1+q0.*exp((mu0).*t))).*(mu0-d0).*X1; %the drug does not affect the enzymes

%store results
dx = [dX1];

end
