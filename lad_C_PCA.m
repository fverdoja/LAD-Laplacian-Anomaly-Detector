function [out, t] = lad_C_PCA(X, e)
%LAD_C_PCA     LAD Detector (PCA, Cauchy distance)
%   This function implements the LAD Detector (using Cauchy distance). 
%   Given the image X, it returns the likelihood map of each pixel to be 
%   anomalous.
%   In this version, RX Detector is computed using a subset of eigenvalues 
%   and eigenvectors. The percentage of energy to be preserved is given by
%   the parameter e. The number of preserved components is given out as t.
%   Parameter e is optional and if not given, its default value is 1, 
%   meaning that all energy is preserved.

if ~exist('e','var')
    e = 1;
end

sizes = size(X);

X = reshape(X, [sizes(1)*sizes(2),sizes(3)]);

M = mean(X);
X = X-repmat(M, [sizes(1)*sizes(2) 1]);

A = abs(bsxfun(@minus,M,M'));
a = mean(M);
A = 1./(1+(A./a).^2);
A = A - eye(size(A));

D = diag(sum(A));
L = D - A;
L = D^(-1/2) * L * D^(-1/2);

[v, l] = eig(L);
[ls, li] = sort(diag(l));
v = real(v(:,li));

y = v'*X';
t = max([1 find(cumsum(sum(y'.^2)/sum(y(:).^2))<=e,1,'last')]);
y = y(1:t,:);
l = repmat(real(ls(1:t)),[1 sizes(1)*sizes(2)]);

out = sum((y.^2).*l, 1);

out = reshape(out, [sizes(1),sizes(2)]);

end