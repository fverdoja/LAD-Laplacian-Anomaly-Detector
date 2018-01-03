function out = implant(I, mask, values)
%IMPLANT     Anomaly implantation
%   Performs anomaly implantation on the image I. The parameter mask has to
%   be a matrix having the same width and heitgh as I, and it's used to
%   determine where the implantation has to occur: all values in the mask
%   have to be in [0,1] range, where zero means no implantation and 1 full
%   implantation; values in between will result in partial implantation.
%   Values to be implanted are taken from the values array passed as
%   parameter in order.

sz = size(I);
out = I;
m = repmat(mask, [1 1 sz(3)]);
pos = find(m);

for i = 1:length(pos)
	out(pos(i)) = (1-m(pos(i))) * out(pos(i)) + m(pos(i)) * values(i);
end

end