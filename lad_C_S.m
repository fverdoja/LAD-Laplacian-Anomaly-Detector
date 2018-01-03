function out = lad_C_S(X)
%LAD_C_S     LAD Detector (Cauchy distance, spatial variant)
%   This function implements the LAD Detector (using Cauchy distance). 
%   Given the image X, it returns the likelihood map of each pixel to be 
%   anomalous.
%   Each pixel is evaluated considering itself and its 4-connected
%   neighbors.

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
out = zeros([sz(1) sz(2)]);

M = mean(x);
x = x-repmat(M, [sz(1)*sz(2) 1]);

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

for k = 1:length(i)
    out(i(k)) = (x(k,:)) * L * (x(k,:))';
end
end