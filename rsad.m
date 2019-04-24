function out = rsad(X, alpha, max_iter)
%RSAD     Random-Selection-Based Anomaly Detector
%   This function implements the RSAD Detector (Du & Zhang, 1990). Given 
%   the image X, it returns the likelihood map of each pixel to be 
%   anomalous. Two optional parameters alpha and max_iter can be passed to 
%   set the threshold to the estimated percentage of anomalous pixels 
%   present in the image and the maximum number of iterations respectively.
%
%   References:
%   Du, B., & Zhang, L. (2011). Random-Selection-Based Anomaly Detector for
%       Hyperspectral Imagery. IEEE Transactions on Geoscience and Remote 
%       Sensing, 49(5), 1578–1589.

if ~exist('alpha','var')
    alpha = 0.01;
end
if ~exist('max_iter','var')
    max_iter = 20;
end

N = 80;
L = 40;

sz = size(X);
n = sz(1)*sz(2);
p = sz(3);
h = (n + p + 1)/2;

X = reshape(X, [n, p]);
out = zeros([n 1]);  
o = zeros([n 1]);  

for l = 1:L
    r = randi(sz(1)-1,N,1);
    c = randi(sz(2)-1,N,1);
    i = r + (c-1) * sz(1);
    ii = [i; i+1; i+sz(1); i+sz(1)+1]; % Indices for N random 2x2 blocks
    
    stop = false;
    iter = 0;
    t = 0;
    while ~stop && iter<max_iter
        Xi = X(ii,:);
        M = mean(Xi);
        C = cov(Xi);
        Q = inv(C);

        for j = 1:n
            x = X(j,:);

            o(j) = sqrt((x - M) * Q * (x - M)');  % Mahalanobis distance
        end
        
        c_hr = max(0, (h-length(ii))/(h+length(ii)));
        c_np = 1 + (p + 1) / (n - p) + 1 / (n - h - p);
        c_npr = c_hr + c_np;
        
        % Threshold
        % t = sqrt(chi2inv(1 - alpha/n, p)) * c_npr;
        t = sqrt(2 * gammaincinv(alpha/n, p/2, 'upper')) * c_npr;
        % this way of computing the threshold is numerically more stable 
        % than by using chi2inv at the upper end of the curve.
        % However, it is algebrically equivalent.
        
        i_new = find(o < t);
        
        if isequal(ii,i_new)
            stop = true;
        else
            ii = i_new;
            iter = iter+1;
        end
    end
    
    out = out + (o >= t);
end

out = out >= L/2; % Pixels are defined anomalous through majority voting
out = reshape(out, [sz(1),sz(2)]);
end