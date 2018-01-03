function [out, t] = lad_C_PCA_S(X, e)
%LAD_C_PCA_S     LAD Detector (PCA, Cauchy distance, spatial variant)
%   This function implements the LAD Detector (using Cauchy distance). 
%   Given the image X, it returns the likelihood map of each pixel to be 
%   anomalous.
%   Each pixel is evaluated considering itself and its 4-connected
%   neighbors.
%   In this version, RX Detector is computed using a subset of eigenvalues 
%   and eigenvectors. The percentage of energy to be preserved is given by
%   the parameter e. The number of preserved components is given out as t.
%   Parameter e is optional and if not given, its default value is 1, 
%   meaning that all energy is preserved.

if ~exist('e','var')
    e = 1;
end

sz = size(X);
c = sz(3);

X = reshape(X, [sz(1)*sz(2) c]);

i = (1:sz(1)*sz(2))';

nb = [0 +1 -1 +sz(1) -sz(1)];

ii = repmat(i, [1 5]);
nbb = repmat(nb, [length(i) 1]);
nii = ismember(ii+nbb, i);
ii = ii + nii.*nbb;
ii = kron(ii, ones([1 c]));

j = ((1:c)-1)*sz(1)*sz(2);
jj = repmat(j, [length(i) 5]);

ij = ii+jj;

x = X(ij);

M = mean(x);
x = x-repmat(M, [sz(1)*sz(2) 1]);
out = zeros([sz(1) sz(2)]);

A = abs(bsxfun(@minus,M,M'));
a = mean(M);
A = 1./(1+(A./a).^2);

n = c*5;
A1 = ones(c);
A2 = eye(c);
Am = zeros(n);
Am(1:c, 1:n) = repmat(A2, [1 5]);
Am(1:n, 1:c) = repmat(A2, [5 1]);
Am(1:c, 1:c) = A1;
Am((c+1):(2*c), (c+1):(2*c)) = A1;
Am((2*c+1):(3*c), (2*c+1):(3*c)) = A1;
Am((3*c+1):(4*c), (3*c+1):(4*c)) = A1;
Am((4*c+1):(5*c), (4*c+1):(5*c)) = A1;
A = A.*Am;
A = A - eye(size(A));

D = diag(sum(A));
L = D - A;
L = D^(-1/2) * L * D^(-1/2);

[v, l] = eig(L);
[ls, li] = sort(diag(l));
v = real(v(:,li));

y = v'*x';
t = max([1 find(cumsum(sum(y'.^2)/sum(y(:).^2))<=e,1,'last')]);
y = y(1:t,:);
l = repmat(real(ls(1:t)),[1 length(i)]);

out(i) = sum((y.^2).*l, 1);

end