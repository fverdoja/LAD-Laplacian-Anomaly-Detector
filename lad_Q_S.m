function out = lad_Q_S(X)
%LAD_Q_S     LAD Detector (partial correlation, spatial variant)
%   This function implements the LAD Detector (using partial correlation). 
%   Given the image X, it returns the likelihood map of each pixel to be 
%   anomalous.
%   Each pixel is evaluated considering itself and its 4-connected
%   neighbors.

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

for k = 1:length(i)
    out(i(k)) = (x(k,:)) * L * (x(k,:))';
end
end