%% Modified Palleti 2017's illustrative network
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
partitionSource = [];
partitionDemand = [1,2,3,4,5,6,7,8,9];
sensorNodes = [];
actuatorPipes = [];
vulnerableNum = 2;
plotBiograph;

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

% Illustrative network, scenario 3, failure
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
