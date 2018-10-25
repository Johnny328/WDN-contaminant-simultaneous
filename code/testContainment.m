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
%% 6 node example network
clear all
adjGraph = sparse([1 1 2 2 2 3 3 4 5], [2 3 4 5 3 4 5 6 6], [2 2 1 1 1 1 1 2 2], 6, 6);
vulnerableNodes = [1,2];
demandNodes = [6];
sourceNodes = [1 2];
edgeWeights = eye(9);
containment
%% Illustrative network, assert weirdness with forced sensors
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [2,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
containment
assert(fval = 3)

%% Illustrative network, assert weirdness with forced sensors
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [2,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
forcedSensors = [6]
containment
assert(fval = 3)

%% Illustrative network, assert weirdness with forced sensors
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [2,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
forcedNoSensors = [7]
containment
assert(fval = 3)