function out = rand_hist(M, n, corr)
%RAND_HIST Random array of values taken from an image
%   Takes n values from the matrix M, having m channels, and returns an n
%   by m matrix of random non-zero values taken from M. The distribution 
%   density function of M is taken into account. For each of the m channels
%   of the output, values are taken from the m-th channel of M. The
%   optional boolean parameter corr, if set to true, enforce that all 
%   channel values for one element of the output array are taken from the 
%   same pixel in M, resulting in correlated inter-channel values; if false
%   all channel values are selected randomly indipendentely, this is the 
%   default behavior.

if ~exist('corr','var')
    corr = 0;
end

sz = size(M);
out = zeros([n sz(3)]);

if corr
    i = find(sum(M,3));
    l = length(i);
    r = round(rand(n,1) .* (l-1) + 1);
    j = i(r);
    [x,y,~] = ind2sub(sz,j);
    for k = 1:n
        out(k,:) = M(x(k),y(k),:);
    end
else
    for i = 1:sz(3)
        s = M(:,:,i);
        [count, cent] = hist(s(s>0),1000);
        PD = [cent' count'];
        PD(:,2) = PD(:,2)/sum(PD(:,2)); % from absolute to relative freqs
        D = cumsum(PD(:,2));
        R = rand(n,1);
        p = @(R) find(R<D,1,'first'); % find the 1st index s.t. r<D(i);
        rR = arrayfun(p,R);
        P = PD(:,1);
        out(:,i) = P(rR);
    end
end

end