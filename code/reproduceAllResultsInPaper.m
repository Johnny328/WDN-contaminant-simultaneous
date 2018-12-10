%% Illustrative network, scenario 1
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
% Force a sensor at node 9
forcedSensors = [9]
multiObj

%% Illustrative network, scenario 2, failure
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
% Force a sensor at node 9
forcedSensors = [9]
try
    containment
end

%% Illustrative network, scenario 2
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
forcedNoSensors = [1,2,7]
containment

%% Illustrative network, scenario 3, failure
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
forcedNoSensors = [1,2,7]
try
    zoneContainment
end

%% Ilustrative network, scenario 3
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
zoneContainment

%% Palleti et al case study multiobj, scenario 1
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
multiObj

%% Palleti 2016 case study zone containment, scenario 3
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
zoneContainment
