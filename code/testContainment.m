%%
clear all
vulnerableN = [131 20] % Verify adjGraph to constraints
containment
%%
clear all
vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
containment
%%
clear all
vulnerableN = [1 2 3] % Original bangalore_expanded network
containment
%% Palleti 2017's illustrative network
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8 8 11],[2 3 4 5 5 6 6 8 9 10 10],[1 1 1 1 1 1 1 1 1 1 1], 11, 11);
vulnerableNodes = [1,7,11]
demandNodes = [3,4,8,9];
sourceNodes = [1,7,11];
%Weights/lengths of pipes
edgeWeights = eye(11);
%edgeWeights = [10 5 11 6 8 5 5 15 10 5 20]; % Unused
tolerance = 10^-4;
containment
