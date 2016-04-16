clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];

%% Bangalore with [131 20], natural
vulnerableN = [131 20] % Verify adjGraph to constraints TODO
zoneContainment
assert(x([457]) == [1000]);
%assert(length(actuatorEdges)+length(sensorNodes) == 4)

%% Same with forced sensor at 20. Need one more sensor, two actuators.
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
vulnerableN = [131 20]
forcedSensors = [20]
zoneContainment
assert(x([457]) == [1000]);
%assert(length(actuatorEdges)+length(sensorNodes) == 4)

%% Same, with maxDistanceToDetection enforcing the sensor at 20.
clear all
demandN = [81 9 83 82 21 80 17 41 79 76 74 78 77 75 73 72 61 63 31 29 85 86 84 70 68];
maxDistanceToDetection = 0
vulnerableN = [131 20]
zoneContainment
assert(x([457]) == [1000]);
%assert(length(actuatorEdges)+length(sensorNodes) == 4)

%%
clear all
%vulnerableN = [1 2 3 19 32 37 39 53 66] % Palleti et al case study
%zoneContainment
%vulnerableN = [1 2 3] % Original bangalore_expanded network
%zoneContainment

%%
clear all
