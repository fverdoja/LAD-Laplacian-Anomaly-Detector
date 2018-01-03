function [out, t] = lad_Q_PCA_S(X, e)
%LAD_Q_PCA_S    LAD Detector (PCA, partial correlation, spatial variant)
%   This function implements the LAD Detector (using partial correlation). 
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

M = mean(X);
X = X-repmat(M, [sz(1)*sz(2) 1]);
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

C = cov(x);
Q = inv(C);
out = zeros([sz(1) sz(2)]);

n = c*5;
A1 = zeros(c);
for p = 1:c-1
	for q = p+1:c
		w = abs(Q(p,q)/sqrt(Q(p,p)*Q(q,q)));
		A1(p,q) = w;
		A1(q,p) = w;
	end
end
A2 = eye(c);
A = zeros(n);
A(1:c, 1:n) = repmat(A2, [1 5]);
A(1:n, 1:c) = repmat(A2, [5 1]);
A(1:c, 1:c) = A1;
A((c+1):(2*c), (c+1):(2*c)) = A1;
A((2*c+1):(3*c), (2*c+1):(3*c)) = A1;
A((3*c+1):(4*c), (3*c+1):(4*c)) = A1;
A((4*c+1):(5*c), (4*c+1):(5*c)) = A1;
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