function w = cauchy(xi, xj, alpha)
%CAUCHY     Cauchy distance
%   Computes Cauchy distance between parameters xi and xj, and uses
%   parameter alpha as scaling factor

d = abs(xi-xj);
w = 1/(1+(d/alpha)^2);

end