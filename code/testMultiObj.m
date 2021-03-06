%% Regression test
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
vulnerableN = [131 20] % Verify adjGraph to constraints
multiObj

%% Palleti et al case study
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
multiObj

%% Bangy case study original, 3V
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
vulnerableN = [1 2 3] % Original bangalore_expanded network
multiObj

%% Palleti 2017's illustrative network
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8 8 11],[2 3 4 5 5 6 6 8 9 10 10],[1 1 1 1 1 1 1 1 1 1 1], 11, 11);
vulnerableNodes = [1,7,11];
demandNodes = [3,4,8,9];
sourceNodes = [1,7,11];
%Weights/lengths of pipes
edgeWeights = eye(11);
%edgeWeights = [10 5 11 6 8 5 5 15 10 5 20]; % Unused
tolerance = 10^-4;
multiObj

%% 6 node example network
clear all
adjGraph = sparse([1 1 2 2 2 3 3 4 5], [2 3 4 5 3 4 5 6 6], [2 2 1 1 1 1 1 2 2], 6, 6);
vulnerableNodes = [1,2];
demandNodes = [6];
sourceNodes = [1 2];
edgeWeights = eye(9);
multiObj
