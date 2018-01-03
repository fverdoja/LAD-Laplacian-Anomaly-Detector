function out = lad_Q(X)
%LAD_Q     LAD Detector (partial correlation)
%   This function implements the LAD Detector (using partial correlation). 
%   Given the image X, it returns the likelihood map of each pixel to be 
%   anomalous.

sizes = size(X);

X = reshape(X, [sizes(1)*sizes(2),sizes(3)]);

M = mean(X);
C = cov(X);
Q = inv(C);

out = zeros([sizes(1)*sizes(2) 1]);

A = zeros(sizes(3));
for i = 1:sizes(3)-1
	for j = i+1:sizes(3)
		w = abs(Q(i,j)/sqrt(Q(i,i)*Q(j,j)));
		A(i,j) = w;
		A(j,i) = w;
	end
end

D = diag(sum(A));
L = D - A;
L = D^(-1/2) * L * D^(-1/2);

for j = 1:sizes(1)*sizes(2)
	x = X(j,:);
	
	out(j) = (x - M) * L * (x - M)';
end

out = reshape(out, [sizes(1),sizes(2)]);

end