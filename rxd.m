function out = rxd(X)
%RXD     RX Detector
%   This function implements the RX Detector (Reed & Yu, 1990). Given the
%   image X, it returns the likelihood map of each pixel to be anomalous.
%
%   References:
%   Reed, I. S., & Yu, X. (1990). Adaptive multiple-band CFAR detection of 
%       an optical pattern with unknown spectral distribution. IEEE Trans.
%       on Acoustics, Speech, and Signal Processing, 38(10), 1760-1770.

sizes = size(X);

X = reshape(X, [sizes(1)*sizes(2), sizes(3)]);

M = mean(X);
C = cov(X);
Q = inv(C);

out = zeros([sizes(1)*sizes(2) 1]);  

for j = 1:sizes(1)*sizes(2)
    x = X(j,:);

    out(j) = (x - M) * Q * (x - M)';  % Mahalanobis distance
end

out = reshape(out, [sizes(1),sizes(2)]);

end