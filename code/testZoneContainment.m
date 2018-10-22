% Starting conditions
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;

%% Bangalore with [131 20]; natural
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
vulnerableN = [131 20] % Verify adjGraph to constraints TODO
zoneContainment
assert(x([457]) - [10000] < tolerance);
assert(length(actuatorEdges)+length(sensorNodes) == 4)

%% Same with forced sensor at 20. Need one more sensor, two actuators.
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
vulnerableN = [131 20]
forcedSensors = [20]
zoneContainment
assert(x([457]) - [10000] < tolerance);
assert(length(actuatorEdges)+length(sensorNodes) == 4)

%% Same, with maxDistanceToDetection enforcing the sensor at 20.
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
maxDistanceToDetection = 0
vulnerableN = [131 20]
zoneContainment
assert(x([457]) - [10000] < tolerance);
assert(length(actuatorEdges)+length(sensorNodes) == 4)

%% The node and edge implementation difference bug
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
vulnerableN = [20]
forcedSensors = [21]
zoneContainment
assert(fval == 4); %Two for the two sensors, two for actuators

%% Palleti et al case study
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
zoneContainment

%% Original bangalore_expanded.inp with 1,2,3 vulnerable
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
vulnerableN = [1 2 3] % Original bangalore_expanded network
zoneContainment

%% Increasing vulnerable nodes to check robustness (and bug which prevents this)
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
% Some extra nodes. Shouldn't cause infeasibilty. Addition of 67 causes infeasibility.
% 78 is demand, can't be in source too.
%vulnerableN = [1 2 3 19 32 37 39 53 66 4 20 33 34 40 47 54 57 67 78 127 129]
vulnerableN = [1 2 3 19 32 37 39 53 66 4 20 33 34 40 47 54 57 67 127 129]
zoneContainment

%% Vulnerable nodes only at the infeasibility causing nodes 3-127-129 thingy
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
%vulnerableN = [1 2 3 19 32 37 39 53 66 4 20 33 34 40 47 54 57 67 78 127 129]
vulnerableN = [3 32 37 39 53 33 34 40 47 54 57 67 127 129]
zoneContainment

%% More infeasible nodes

%% Actuator placement at least one node after vulnerable.
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
tolerance = 10^-4;
% Some extra nodes. Shouldn't cause infeasibilty. 78 is demand, don't include.
% nodesNextToVulnerableNodes= [4 20 33 34 40 47 54 57 67 78 127 129]
vulnerableN = [1 2 3 19 32 37 39 53 66]
nodesNextToVulnerableNodes = [4 20 33 34 40 47 54 57 67 127 129]
zoneContainment

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
zoneContainment
