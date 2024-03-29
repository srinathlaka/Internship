%==========================================================================
%
% inorm  2-norm of a vector (complexified version of norm).
%
%   y = inorm(x)
%
% See also norm.
%
% Copyright © 2021 Tamas Kis
% Last Update: 2022-11-12
% Website: https://tamaskis.github.io
% Contact: tamas.a.kis@outlook.com
%
% TOOLBOX DOCUMENTATION:
% https://tamaskis.github.io/Numerical_Differentiation_Toolbox-MATLAB/
%
% TECHNICAL DOCUMENTATION:
% https://tamaskis.github.io/files/Numerical_Differentiation.pdf
%
%--------------------------------------------------------------------------
%
% ------
% INPUT:
% ------
%   x       - (n×1 complex) input argument
%
% -------
% OUTPUT:
% -------
%   y       - (1×1 complex) 2-norm of x
%
%==========================================================================
function y = inorm(x)
    y = sqrt(x.'*x);
end