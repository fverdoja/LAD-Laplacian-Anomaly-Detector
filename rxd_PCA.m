function [out, t] = rxd_PCA(X, e)
%RXD_PCA     RX Detector (PCA)
%   This function implements the RX Detector (Reed & Yu, 1990). Given the
%   image X, it returns the likelihood map of each pixel to be anomalous.
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

sizes = size(X);

X = reshape(X, [sizes(1)*sizes(2),sizes(3)]);

M = mean(X);
X = X-repmat(M, [sizes(1)*sizes(2) 1]);
C = cov(X);

[v, l] = eig(C);
[ls, li] = sort(diag(l), 'descend');
v = real(v(:,li));

y = v'*X';
t = max([1 find(cumsum(sum(y'.^2)/sum(y(:).^2))<=e,1,'last')]);
y = y(1:t,:);
l = repmat(real(ls(1:t)),[1 sizes(1)*sizes(2)]);

out = sum((y.^2)./l, 1);

out = reshape(out, [sizes(1),sizes(2)]);

end