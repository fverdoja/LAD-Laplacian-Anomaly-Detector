function [out, t] = rxd_PCA_S(X, e)
%RXD_PCA_S     RX Detector (PCA, spatial variant)
%   This function implements the RX Detector (Reed & Yu, 1990). Given the
%   image X, it returns the likelihood map of each pixel to be anomalous.
%   Each pixel is evaluated considering itself and its 4-connected
%   neighbors.
%   In this version, RX Detector is computed using a subset of eigenvalues 
%   and eigenvectors. The percentage of energy to be preserved is given by
%   the parameter e. The number of preserved components is given out as t.
%   Parameter e is optional and if not given, its default value is 1, 
%   meaning that all energy is preserved.
%
%   References:
%   Reed, I. S., & Yu, X. (1990). Adaptive multiple-band CFAR detection of 
%       an optical pattern with unknown spectral distribution. IEEE Trans.
%       on Acoustics, Speech, and Signal Processing, 38(10), 1760-1770.

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

out = zeros([sz(1) sz(2)]);

[v, l] = eig(C);
[ls, li] = sort(diag(l), 'descend');
v = real(v(:,li));

y = v'*x';
t = max([1 find(cumsum(sum(y'.^2)/sum(y(:).^2))<=e,1,'last')]);
y = y(1:t,:);
l = repmat(real(ls(1:t)),[1 length(i)]);

out(i) = sum((y.^2)./l, 1);

end