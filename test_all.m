%TEST_ALL Tests a selection of algorithms against all test scenarios
clear;

% shortcuts for true and false (used in algs and tests structs)
T = true;
F = false;

%% Algorithms and parameters
% Set the lines of the algs struct for the algorithms to be tested to T. 
% The ones not to be tested have to be set to F.
algs = struct( ...
    'RXD', {@rxd, T}, ...
    'WSCF', {@wscf, T}, ...
    'RSAD', {@rsad, T}, ...
    'LAD_Q', {@lad_Q, T}, ...
    'LAD_Q_S', {@lad_Q_S, T}, ...
    'LAD_C', {@lad_C, T}, ...
    'LAD_C_S', {@lad_C_S, T}, ...
    'RXD_PCA', {@rxd_PCA, T}, ...
    'LAD_Q_PCA', {@lad_Q_PCA, T}, ...
    'LAD_Q_PCA_S', {@lad_Q_PCA_S, T}, ...
    'LAD_C_PCA', {@lad_C_PCA, T}, ...
    'LAD_C_PCA_S', {@lad_C_PCA_S, T} ...
    );
algs_names = fieldnames(algs);

% Set the lines of the tests struct for the scenarios to be performed to T.
% The ones not to be performed have to be set to F.
tests = struct( ...
    'IMPL4', T, ...
    'IMPL14', T, ...
    'REAL', T, ...
    'URBAN1', T, ...
    'URBAN2', T ...
    );

% e is the energy to be preserved for the PCA-like methods
e = 0.99;
% pp is an array containing all threshold to be tested as percentage of the
% max distance.
pp = 0:0.02:1;


%% Implanted anomaly 4
if tests.IMPL4
    load('data/salinas/salinas_impl_4.mat');
    load('data/salinas/salinas_impl_gt.mat');

    all_res_IMPL4 = zeros([1 length(algs_names)]);
    all_t_IMPL4   = zeros([1 length(algs_names)]);
    all_p_IMPL4   = zeros([1 length(algs_names)]);
    all_roc_IMPL4 = zeros([length(pp) length(algs_names) 2]);

    disp('########### IMPLANTED 4');
    for i = 1:length(algs_names)
        alg_name = algs_names{i};
        alg_f = algs(1).(alg_name);
        alg_test = algs(2).(alg_name);
        if alg_test
            disp(['## ' alg_name]);
            tic
            if nargin(alg_f) == 1 % used for most algorithms
                out = alg_f(X);
                t = -1;
            elseif nargin(alg_f) == 2 % used for PCA-like algorithms
                [out, t] = alg_f(X, e);
            else % used for RSAD
                alpha = nnz(gt)/numel(gt)
                out = alg_f(X, alpha);
                t = -1;
            end
            toc
            
            if islogical(out)
                imshow(out); drawnow
                this_p = -1;
                this_res = metrics(out, gt);
                this_roc = zeros([length(pp) 2]);
            else
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
                % disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
                end
            end

            all_res_IMPL4(i) = this_res(7);
            all_t_IMPL4(i) = t;
            all_p_IMPL4(i) = this_p;
            all_roc_IMPL4(:,i,:) = this_roc;

            disp(['BEST: t = ' num2str(all_t_IMPL4(i)) '; p = ' ...
                num2str(this_p) '; SOI = ' num2str(all_res_IMPL4(i))]);
        end
    end
end


%% Implanted anomaly 14
if tests.IMPL14
    load('data/salinas/salinas_impl_14.mat');
    load('data/salinas/salinas_impl_gt.mat');

    all_res_IMPL14 = zeros([1 length(algs_names)]);
    all_t_IMPL14   = zeros([1 length(algs_names)]);
    all_p_IMPL14   = zeros([1 length(algs_names)]);
    all_roc_IMPL14 = zeros([length(pp) length(algs_names) 2]);

    disp('########### IMPLANTED 14');
    for i = 1:length(algs_names)
        alg_name = algs_names{i};
        alg_f = algs(1).(alg_name);
        alg_test = algs(2).(alg_name);
        if alg_test
            disp(['## ' alg_name]);
            tic
            if nargin(alg_f) == 1 % used for most algorithms
                out = alg_f(X);
                t = -1;
            elseif nargin(alg_f) == 2 % used for PCA-like algorithms
                [out, t] = alg_f(X, e);
            else % used for RSAD
                alpha = nnz(gt)/numel(gt)
                out = alg_f(X, alpha);
                t = -1;
            end
            toc
            
            if islogical(out)
                imshow(out); drawnow
                this_p = -1;
                this_res = metrics(out, gt);
                this_roc = zeros([length(pp) 2]);
            else
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
                % disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
                end
            end

            all_res_IMPL14(i) = this_res(7);
            all_t_IMPL14(i) = t;
            all_p_IMPL14(i) = this_p;
            all_roc_IMPL14(:,i,:) = this_roc;

            disp(['BEST: t = ' num2str(all_t_IMPL14(i)) '; p = ' ...
                num2str(this_p) '; SOI = ' num2str(all_res_IMPL14(i))]);
        end
    end
end


%% Real anomaly
if tests.REAL
    load('data/salinas/salinas.mat');
    load('data/salinas/salinas_gt.mat');

    all_res_REAL = zeros([1 length(algs_names)]);
    all_t_REAL   = zeros([1 length(algs_names)]);
    all_p_REAL   = zeros([1 length(algs_names)]);
    all_roc_REAL = zeros([length(pp) length(algs_names) 2]);

    disp('########### REAL');
    for i = 1:length(algs_names)
        alg_name = algs_names{i};
        alg_f = algs(1).(alg_name);
        alg_test = algs(2).(alg_name);
        if alg_test
            disp(['## ' alg_name]);
            tic
            if nargin(alg_f) == 1 % used for most algorithms
                out = alg_f(X);
                t = -1;
            elseif nargin(alg_f) == 2 % used for PCA-like algorithms
                [out, t] = alg_f(X, e);
            else % used for RSAD
                alpha = nnz(gt)/numel(gt)
                out = alg_f(X, alpha);
                t = -1;
            end
            toc
            
            if islogical(out)
                imshow(out); drawnow
                this_p = -1;
                this_res = metrics(out, gt);
                this_roc = zeros([length(pp) 2]);
            else
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
                % disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
                end
            end

            all_res_REAL(i) = this_res(7);
            all_t_REAL(i) = t;
            all_p_REAL(i) = this_p;
            all_roc_REAL(:,i,:) = this_roc;

            disp(['BEST: t = ' num2str(all_t_REAL(i)) '; p = ' ...
                num2str(this_p) '; SOI = ' num2str(all_res_REAL(i))]);
        end
    end    
end


%% Urban 1
if tests.URBAN1
    load('data/ABU/urban-1.mat');
    X = data;
    gt = map;

    all_res_ABU1 = zeros([1 length(algs_names)]);
    all_t_ABU1   = zeros([1 length(algs_names)]);
    all_p_ABU1   = zeros([1 length(algs_names)]);
    all_roc_ABU1 = zeros([length(pp) length(algs_names) 2]);

    disp('########### URBAN 1');
    for i = 1:length(algs_names)
        alg_name = algs_names{i};
        alg_f = algs(1).(alg_name);
        alg_test = algs(2).(alg_name);
        if alg_test
            disp(['## ' alg_name]);
            tic
            if nargin(alg_f) == 1 % used for most algorithms
                out = alg_f(X);
                t = -1;
            elseif nargin(alg_f) == 2 % used for PCA-like algorithms
                [out, t] = alg_f(X, e);
            else % used for RSAD
                alpha = nnz(gt)/numel(gt)
                out = alg_f(X, alpha);
                t = -1;
            end
            toc
            
            if islogical(out)
                imshow(out); drawnow
                this_p = -1;
                this_res = metrics(out, gt);
                this_roc = zeros([length(pp) 2]);
            else
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
                % disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
                end
            end

            all_res_ABU1(i) = this_res(7);
            all_t_ABU1(i) = t;
            all_p_ABU1(i) = this_p;
            all_roc_ABU1(:,i,:) = this_roc;

            disp(['BEST: t = ' num2str(all_t_ABU1(i)) '; p = ' ...
                num2str(this_p) '; SOI = ' num2str(all_res_ABU1(i))]);
        end
    end
end


%% Urban 2
if tests.URBAN2
    load('data/ABU/urban-2.mat');
    X = data;
    gt = map;

    all_res_ABU2 = zeros([1 length(algs_names)]);
    all_t_ABU2   = zeros([1 length(algs_names)]);
    all_p_ABU2   = zeros([1 length(algs_names)]);
    all_roc_ABU2 = zeros([length(pp) length(algs_names) 2]);

    disp('########### URBAN 2');
    for i = 1:length(algs_names)
        alg_name = algs_names{i};
        alg_f = algs(1).(alg_name);
        alg_test = algs(2).(alg_name);
        if alg_test
            disp(['## ' alg_name]);
            tic
            if nargin(alg_f) == 1 % used for most algorithms
                out = alg_f(X);
                t = -1;
            elseif nargin(alg_f) == 2 % used for PCA-like algorithms
                [out, t] = alg_f(X, e);
            else % used for RSAD
                alpha = nnz(gt)/numel(gt)
                out = alg_f(X, alpha);
                t = -1;
            end
            toc
            
            if islogical(out)
                imshow(out); drawnow
                this_p = -1;
                this_res = metrics(out, gt);
                this_roc = zeros([length(pp) 2]);
            else
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
                % disp(['p: ' num2str(p) ' - SOI: ' num2str(restemp(7))]);
                end
            end

            all_res_ABU2(i) = this_res(7);
            all_t_ABU2(i) = t;
            all_p_ABU2(i) = this_p;
            all_roc_ABU2(:,i,:) = this_roc;

            disp(['BEST: t = ' num2str(all_t_ABU2(i)) '; p = ' ...
                num2str(this_p) '; SOI = ' num2str(all_res_ABU2(i))]);
        end
    end
end