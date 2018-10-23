%% 6 node example network
clear all
adjGraph = sparse([1 1 2 2 2 3 3 4 5], [2 3 4 5 3 4 5 6 6], [2 2 1 1 1 1 1 2 2], 6, 6);
vulnerableNodes = [1,2];
demandNodes = [6];
sourceNodes = [1 2];
edgeWeights = eye(11);
partitionSource = [];
partitionDemand = [1,2,3,4,5,6];
sensorNodes = [];
actuatorPipes = [];
vulnerableNum = 2;
plotBiograph

%% Modified Palleti 2017's illustrative network
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
%Weights/lengths of pipes
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
%edgeWeights = [10 5 11 6 8 5 5 15 10 5 20]; % Unused
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
%Weights/lengths of pipes
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
%edgeWeights = [10 5 11 6 8 5 5 15 10 5 20]; % Unused
tolerance = 10^-4;
% Force a sensor at node 9
forcedSensors = [9]
multiObj

%% Illustrative network, scenario 2, failure
clear all
adjGraph = sparse([1 2 2 3 4 5 7 6 8],[2 3 4 5 5 6 6 8 9],[1 1 1 1 1 1 1 1 1], 9, 9);
vulnerableNodes = [1,7];
demandNodes = [3,4,8,9];
sourceNodes = [1,7];
%Weights/lengths of pipes
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
%edgeWeights = [10 5 11 6 8 5 5 15 10 5 20]; % Unused
tolerance = 10^-4;
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
%Weights/lengths of pipes
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
%Weights/lengths of pipes
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
%Weights/lengths of pipes
nodesNum = size(adjGraph,1);
edgeWeights = eye(nodesNum);
%edgeWeights = [10 5 11 6 8 5 5 15 10 5 20]; % Unused
tolerance = 10^-4;
zoneContainment
