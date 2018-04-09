function out = wscf(X)
%RXD     WSCF Detector
%   This function implements the WSCF Detector. Given the image X, it 
%   returns the likelihood map of each pixel to be anomalous. Alpha is set 
%   to 0.2, as proposed by the original authors.
%
%   References:
%   J. M. Gaucel, M. Guillaume, and S. Bourennane, "Whitening spatial 
%       correlation filtering for hyperspectral anomaly detection," in 
%       Proceedings. (ICASSP ’05). IEEE International Conference on 
%       Acoustics, Speech, and Signal Processing, 2005., 2005, vol. 5, p. 
%       v/333-v/336 Vol. 5.

alpha = 0.2;

sz = size(X);

X = reshape(X, [sz(1)*sz(2), sz(3)]);

M = mean(X);
X = X-repmat(M, [sz(1)*sz(2) 1]);
C = cov(X);

[v, l] = eig(C);
Xw = (l'^(-0.5) * v' * X')';

out = zeros([sz(1)*sz(2) 1]);

nbr = [-1 +0 +1 -1 +1 -1 +0 +1];
nbc = [-1 -1 -1 +0 +0 +1 +1 +1];

for r = 1:sz(1)
    for c = 1:sz(2)
        i = r + sz(1)*(c-1);
        
        vr = max(1, min(sz(1), r + nbr));
        vc = max(1, min(sz(2), c + nbc));
        vi = vr + sz(1)*(vc-1);
                
        xi = Xw(i,:);
        xi2 = xi*xi';

        snb = 0;
        for j = vi
            xj = Xw(j,:);
            snb = snb + (xi*xj')/xi2;
        end

        out(i) = norm(xi) * (1 + alpha * snb);
    end
end

out = reshape(out, [sz(1),sz(2)]);

end