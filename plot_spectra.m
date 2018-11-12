%PLOT_SPECTRA Plots spectra for background and implanted anomalies
clear;

%% Load images
load('salinas_impl_4.mat');
X2 = X;
load('salinas_impl_14.mat');

load('salinas_impl_gt.mat');

% load('salinas.mat');
% load('salinas_gt.mat');
% X2 = X;

%% Parameter
% If N = 0, mean and std of all points in a region are plotted
% If N > 0, the individual spectra for N random elements in a region are
%           plotted instead
N = 0;

%% Get the elements
sz = size(X);

ai = find(gt);
bi = find(1-gt);
if N
    ar = randi(length(ai), 1, N);
    br = randi(length(bi), 1, N);
    ai = ai(ar);
    bi = bi(br);
end

X_ = reshape(X, sz(1)*sz(2), sz(3));
X2_ = reshape(X2, sz(1)*sz(2), sz(3));

A = X_(ai,:);
A2 = X2_(ai,:);
B = X_(bi,:);

%% Plot the elements
x = (0:sz(3)-1)';
if N
    figure; hold on;
    for i = 1:N
        plot(x,A(i,:),'b')
        plot(x,A2(i,:),'g')
        plot(x,B(i,:),'r')
    end
    hold off;
else
    mA = mean(A)';
    mA2 = mean(A2)';
    mB = mean(B)';
    sA = std(A)';
    sA2 = std(A2)';
    sB = std(B)';
    figure; hold on;
    fill([x;flipud(x)],[mA-sA;flipud(mA+sA)],[.8 .8 1],'linestyle','none');
    fill([x;flipud(x)],[mA2-sA2;flipud(mA2+sA2)],[.8 1 .8],'linestyle','none');
    fill([x;flipud(x)],[mB-sB;flipud(mB+sB)],[1 .8 .8],'linestyle','none');
    plot(x, mA, 'b');
    plot(x, mA2, 'g');
    plot(x, mB, 'r');
    hold off;
end