%TEST_ALL Tests a selection of algorithms against all test scenarios
clear;

%% Algorithms and parameters
% Comment the lines of the algs array for the algorithms that aren't to be 
% tested.
algs = {
    @rxd, @rxd_S, ...
    @wscf, ...
    @lad_Q, @lad_Q_S, ...
    @lad_C, @lad_C_S, ...
    @rxd_PCA, @rxd_PCA_S, ...
    @lad_Q_PCA, @lad_Q_PCA_S, ...
    @lad_C_PCA, @lad_C_PCA_S, ...
    };
% e is the energy to be preserved for the PCA-like methods
e = 0.99;
% pp is an array containing all threshold to be tested as percentage of the
% max distance.
pp = 0:0.02:1;


%% Implanted anomaly 4
load('salinas_impl_4.mat');
load('salinas_impl_gt.mat');
X = o(75:200,:,:);
gt = g(75:200,:,:);

all_res_IMPL4 = zeros([1 length(algs)]);
all_t_IMPL4   = zeros([1 length(algs)]);
all_p_IMPL4   = zeros([1 length(algs)]);
all_roc_IMPL4 = zeros([length(pp) length(algs) 2]);

disp('########### IMPLANTED 4');
for i = 1:length(algs)
    disp(['## ' func2str(algs{i})]);
    if nargin(algs{i}) == 1
        out = algs{i}(X);
        t = -1;
    else
        [out, t] = algs{i}(X, e);
    end
    
    this_p = 0;
    this_res = metrics(out>=0, gt);
    this_roc = zeros([length(pp) 2]);
    j = 1;
    for p = pp
        restemp = metrics(out>max(out(:))*p, gt);
        this_roc(j,1) = restemp(4);
        this_roc(j,2) = restemp(3);
        j=j+1;
        if restemp(7) > this_res(7)
            this_res = restemp;
            this_p = p;
        end
%         disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
    end
    
    all_res_IMPL4(i) = this_res(7);
    all_t_IMPL4(i) = t;
    all_p_IMPL4(i) = this_p;
    all_roc_IMPL4(:,i,:) = this_roc;
    
    disp(['BEST: t = ' num2str(all_t_IMPL4(i)) '; p = ' num2str(this_p) ...
        '; SOI = ' num2str(all_res_IMPL4(i))]);
end


%% Real anomaly
load('salinas.mat');
load('salinas_gt.mat');
X = sal(1:150,:,:);
gt = sal_gt(1:150,:,:);

all_res_REAL = zeros([1 length(algs)]);
all_t_REAL   = zeros([1 length(algs)]);
all_p_REAL   = zeros([1 length(algs)]);
all_roc_REAL = zeros([length(pp) length(algs) 2]);

disp('########### NORMAL');
for i = 1:length(algs)
    disp(['## ' func2str(algs{i})]);
    if nargin(algs{i}) == 1
        out = algs{i}(X);
        t = -1;
    else
        [out, t] = algs{i}(X, e);
    end
    
    this_p = 0;
    this_res = metrics(out>=0, gt);
    this_roc = zeros([length(pp) 2]);
    j = 1;
    for p = pp
        restemp = metrics(out>max(out(:))*p, gt);
        this_roc(j,1) = restemp(4);
        this_roc(j,2) = restemp(3);
        j=j+1;
        if restemp(7) > this_res(7)
            this_res = restemp;
            this_p = p;
        end
%         disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
    end
    
    all_res_REAL(i) = this_res(7);
    all_t_REAL(i) = t;
    all_p_REAL(i) = this_p;
    all_roc_REAL(:,i,:) = this_roc;
    
    disp(['BEST: t = ' num2str(all_t_REAL(i)) '; p = ' num2str(this_p) ...
        '; SOI = ' num2str(all_res_REAL(i))]);
end


%% Implanted anomaly 14
load('salinas_impl_14.mat');
load('salinas_impl_gt.mat');
X = o(75:200,:,:);
gt = g(75:200,:,:);

all_res_IMPL14 = zeros([1 length(algs)]);
all_t_IMPL14   = zeros([1 length(algs)]);
all_p_IMPL14   = zeros([1 length(algs)]);
all_roc_IMPL14 = zeros([length(pp) length(algs) 2]);

disp('########### IMPLANTED 14');
for i = 1:length(algs)
    disp(['## ' func2str(algs{i})]);
    if nargin(algs{i}) == 1
        out = algs{i}(X);
        t = -1;
    else
        [out, t] = algs{i}(X, e);
    end
    
    this_p = 0;
    this_res = metrics(out>=0, gt);
    this_roc = zeros([length(pp) 2]);
    j = 1;
    for p = pp
        restemp = metrics(out>max(out(:))*p, gt);
        this_roc(j,1) = restemp(4);
        this_roc(j,2) = restemp(3);
        j=j+1;
        if restemp(7) > this_res(7)
            this_res = restemp;
            this_p = p;
        end
%         disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
    end
    
    all_res_IMPL14(i) = this_res(7);
    all_t_IMPL14(i) = t;
    all_p_IMPL14(i) = this_p;
    all_roc_IMPL14(:,i,:) = this_roc;
    
    disp(['BEST: t = ' num2str(all_t_IMPL14(i)) '; p = ' num2str(this_p) ...
        '; SOI = ' num2str(all_res_IMPL14(i))]);
end