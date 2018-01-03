function result = metrics(output, groundtruth)
%METRICS    Evaluation metrics
%   Computes some metrics of the segmentation output with respect to a 
%   ground truth. Both parameters has to be binary matrices of the same 
%   size.
%   The output of the function is an array containing in order
%   Outputs:
%    - numel(groundtruth): number of non-zero elements in the ground truth
%    - numel(output): number of non-zero elements in the thresholded output
%                     of the detector
%    - Tpr: True Positives rate
%    - Fpr: False Positives rate
%    - Fnr: False Negatives rate
%    - Tnr: True Negatives rate
%    - soi: SOI metric (also known as Dice Coefficient or F1-measure)
%    - ce: Classification Error metric

A = find(groundtruth);
B = find(output);

P = numel(A);
N = numel(output)-numel(A);
Tp = numel(intersect(A, B));
Fp = numel(setdiff(B, A));
Fn = numel(setdiff(A, B));
Tn = numel(output)-numel(union(A, B));
Tpr = Tp/P;
Fnr = Fn/P;
Fpr = Fp/N;
Tnr = Tn/N;
soi = 2*Tp/(2*Tp+Fp+Fn);
ce = 100*(Fp+Fn)/P;

result = [P numel(B) Tpr Fpr Fnr Tnr soi ce];

end