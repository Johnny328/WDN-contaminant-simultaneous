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
assert(fval == 3); %Two for the two sensors, one for actuator

%% Palleti et al case study
%clear all
%vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
%zoneContainment

%% Original bangalore_expanded.inp with 1,2,3 vulnerable
%vulnerableN = [1 2 3] % Original bangalore_expanded network
%zoneContainment

