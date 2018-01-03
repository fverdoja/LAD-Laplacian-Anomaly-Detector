function out = rxd_S(X)
%RXD_S     RX Detector (spatial variant)
%   This function implements the RX Detector (Reed & Yu, 1990). Given the
%   image X, it returns the likelihood map of each pixel to be anomalous.
%   Each pixel is evaluated considering itself and its 4-connected
%   neighbors.
%
%   References:
%   Reed, I. S., & Yu, X. (1990). Adaptive multiple-band CFAR detection of 
%       an optical pattern with unknown spectral distribution. IEEE Trans.
%       on Acoustics, Speech, and Signal Processing, 38(10), 1760-1770.

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

for k = 1:length(i)
	out(i(k)) = (x(k,:)) * Q * (x(k,:))';  % Mahalanobis distance
end

end