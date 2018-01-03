function out = lad_C(X)
%LAD_C     LAD Detector (Cauchy distance)
%   This function implements the LAD Detector (using Cauchy distance). 
%   Given the image X, it returns the likelihood map of each pixel to be 
%   anomalous.

sizes = size(X);

X = reshape(X, [sizes(1)*sizes(2),sizes(3)]);

M = mean(X);

out = zeros([sizes(1)*sizes(2) 1]);

A = abs(bsxfun(@minus,M,M'));
a = mean(M);
A = 1./(1+(A./a).^2);
A = A - eye(size(A));

D = diag(sum(A));
L = D - A;
L = D^(-1/2) * L * D^(-1/2);

for j = 1:sizes(1)*sizes(2)
	x = X(j,:);
	
	out(j) = (x - M) * L * (x - M)';
end

out = reshape(out, [sizes(1),sizes(2)]);
end