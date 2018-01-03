function w = gauss(xi, xj, alpha)
%GAUSS     Gauss distance
%   Computes Gauss distance between parameters xi and xj, and uses
%   parameter alpha as scaling factor

d = abs(xi-xj);
w = exp(-(d/alpha)^2);

end