function [dx] = ModelMonodODE(t,x,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
k0 = parameters.k0;
y0 = parameters.y0;

%define the variables
X1 = x(1);
X2 = x(2);

%ODE
dX1 = mu0.*(X2./(k0+X2)).*X1;
dX2 = -(1./y0).*mu0.*(X2./(k0+X2)).*X1;


% q0 = 0.055;
% dX1 = mu0.*(X2./(k0+X2)).*X1.*(q0.*exp(mu0.*t)./(1+q0.*exp(mu0.*t)));
% dX2 = -(1./y0).*mu0.*(X2./(k0+X2)).*X1.*(q0.*exp(mu0.*t)./(1+q0.*exp(mu0.*t)));


%store results
dx = [dX1;dX2];

end
