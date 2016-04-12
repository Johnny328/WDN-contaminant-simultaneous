% Get data from .inp file
[model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, vulnerableNum, demandNodes, pipeIDs, nodeIDs, pipeStartNodes, pipeEndNodes] = getWdnData('bangalore_expanded221.inp');
if(exist('vulnerableN'))
    vulnerableNodes = vulnerableN;
    vulnerableNum = length(vulnerableNodes);
end
NUMBER_BIGGER_THAN_NETWORK = 10000;
floatTolerance = 1/NUMBER_BIGGER_THAN_NETWORK;
if(exist('maxDistanceToDetection')==0) 
    maxDistanceToDetection = NUMBER_BIGGER_THAN_NETWORK;
end

%% Sensor placement
% Given vulnerable, find affected for each vulnerable
% 1 step away affected nodes
% affectedN = adjGraph(vulnerableN,:)>=1;
% Find all affected nodes per vulnerable node, each vulnerable node has a row in the A matrix
A1 = zeros(vulnerableNum,nodesNum);
for i=1:vulnerableNum
    tmp1 = graphtraverse(adjGraph,vulnerableNodes(i));
    A1(i,tmp1) = -1;
end
%Decision variable coefficient vector -- f
f1 = ones(nodesNum,1);
%Constraints -Ax >= -b; where (-b)=1
b1 = -1.*ones(size(A1,1),1);
%Integer variables
intcon1 = 1:nodesNum;
%Equality constraints
Aeq1 = zeros(0,size(f1,1));
beq1 = [];

% Forcing sensors at these point to see obj. fun. value.
if(exist('forcedSensors'))
    Aeq1i = 0;
    for i=forcedSensors
        Aeq1i = Aeq1i + 1;
        Aeq1(Aeq1i,i) = 1;
end
beq1 = ones(Aeq1i,1);
end
%% Actuator placement %Inspired by Venkat Reddy's implementation of partitioning.
%Objective
f2 = [zeros(1,size(incGraph,2)), ones(1,size(incGraph,1))]';

% Inequality constraint 
% TODO This does not account for zero flows or demand to source transitions
% when flow is opposite.
A2 = [-incGraph -eye(size(incGraph,1))*edgeWeights];
%incGraph -eye(size(incGraph,1))*edgeWeights]; % TODO edgeWeights must be in the order of incGraph (1:size(incGraph,1) === pipeIDs)
b2 = zeros(size(incGraph,1),1);

% Set the partitions of source to 0 and demands to 1
% Equality constraint
Aeq2i = 0;
Aeq2 = zeros(0,size(f2,1));
for i=vulnerableNodes
    Aeq2i = Aeq2i+1;
    Aeq2(Aeq2i,i) = 1;
end
beq2 = zeros(vulnerableNum,1);
for i=demandNodes
    Aeq2i = Aeq2i+1;
    Aeq2(Aeq2i,i) = 1;
end
beq2 = [beq2; ones(length(demandNodes),1)];

% Get the distances to be needed among the nodes.
tmp2 = graphallshortestpaths(adjGraph);
allDistances = tmp2(vulnerableNodes,:);
assert(isequal(size(allDistances), [vulnerableNum nodesNum]));
shortestPathsFromVulnerableNodes = min(allDistances);
tmp3 = sort(shortestPathsFromVulnerableNodes);
maxDistance = tmp3(end-1);
shortestPathsFromVulnerableNodes(shortestPathsFromVulnerableNodes==Inf) = NUMBER_BIGGER_THAN_NETWORK;
distanceEdgesFromAllVulnerableNodes = shortestPathsFromVulnerableNodes(pipeStartNodes);
allDistances(allDistances==Inf) = NUMBER_BIGGER_THAN_NETWORK; % TODO check effects.
distanceEdgesFromVulnerableNodes = allDistances(:,pipeStartNodes);

%% Solving combined MILP
%Integer constraint
intcon2 = nodesNum+1:nodesNum*2+edgesNum;

% Decision variables for transformed space.
f3 = [NUMBER_BIGGER_THAN_NETWORK.*ones(vulnerableNum,1) ; zeros(nodesNum,1)];
intcon3 = (nodesNum*2+edgesNum+1):(nodesNum*2+edgesNum + vulnerableNum + nodesNum);

% Lower and upper bounds/bianry constraint
lowerBound = [zeros(1,nodesNum*2+edgesNum + vulnerableNum) ones(1,nodesNum)];
upperBound = [ones(1,nodesNum*2+edgesNum) NUMBER_BIGGER_THAN_NETWORK.*ones(1,vulnerableNum + nodesNum)];

A = [A1 zeros(size(A1,1),size(f2,1)+size(f3,1)); 
zeros(size(A2,1),size(f1,1)) A2 zeros(size(A2,1),size(f3,1))];
b = [b1;b2];
Aeq = [Aeq1 zeros(size(Aeq1,1),size(f2,1)+size(f3,1));
zeros(size(Aeq2,1),size(f1,1)) Aeq2 zeros(size(Aeq2,1),size(f3,1))];
beq = [beq1;beq2];
f = [f1;f2;f3];
intcon = [intcon1 intcon2 intcon3];
%intcon = []; % Test if infeasibility is beacuse of intcon.

%Use inequality constraints to force sensor nodes(and all nodes at or lesser distance from vulnerable nodes) to be in the source
%partition. Observability => all are critical, can make another objective
%for identifiability easily.

% Get min sensor distance for each vulnerable node
for j=1:vulnerableNum
    for i=1:nodesNum % We could take only the nodes which are on the path of that particular vulN. Same at other places.
        index = size(A,1)+1;
        A(index,i) = NUMBER_BIGGER_THAN_NETWORK - allDistances(j,i); % TODO edge case of allDistance = NUMBER_BIGGER_THAN_NETWORK
        A(index,nodesNum*2+edgesNum+j) = -1;
    end
end
b = [b; zeros(nodesNum*vulnerableNum,1)];
% Equality constraints for making it equal to the minimum sensor distance. One such constraint being satisfied is enough.
for j=1:vulnerableNum
    for i=1:nodesNum
        index = size(A,1)+1;
        A(index,i) = allDistances(j,i);
        A(index,nodesNum*2+edgesNum+j) = 1;
        %TODO verify, freaking brilliant heuristic
        %A(index,nodesNum+i) = -NUMBER_BIGGER_THAN_NETWORK;
    end
end
b = [b; NUMBER_BIGGER_THAN_NETWORK.*ones(nodesNum*vulnerableNum,1)];
% Enforcing at least one such constraint being satisfied.
%index = size(A,1)+1;
%for j=1:vulnerableNum
%    A(index,1:size(A1,2)) = A1(j,:); %TODO is this portable?
%    %A(index,:) = A(j,:); % This is the number of constraints active for the vulnerable node, the number of affected sensors
%    A(index,nodesNum*2+edgesNum+vulnerableNum+j) = 1;
%end
%b = [b; vulnerableNum-1];

% Maximum distance to detection enforcing
for j=1:vulnerableNum
    A(size(A,1)+1,nodesNum*2+edgesNum+j) = -1;
    b(size(b,1)+1) = maxDistanceToDetection - NUMBER_BIGGER_THAN_NETWORK;
end

% Make the partition vector 1 for demand partition and NUMBER_BIGGER_THAN_NETWORK for source.
% Decision variables bounds [1, NUMBER_BIGGER_THAN_NETWORK]. Don't maximize. 
for i=1:nodesNum
    index = size(A,1)+1;
    A(index,nodesNum+i) = -NUMBER_BIGGER_THAN_NETWORK;
    A(index,nodesNum*2+edgesNum+vulnerableNum+i) = -1;
    b(index) = -NUMBER_BIGGER_THAN_NETWORK; 
    index = size(A,1)+1;
    A(index,nodesNum+i) = (NUMBER_BIGGER_THAN_NETWORK-1);
    A(index,nodesNum*2+edgesNum+vulnerableNum+i) = 1;
    b(index) = NUMBER_BIGGER_THAN_NETWORK; 
end

% Force all partitioning to happen after the stored minimum distance to each vulnerable node.
%for i=1:nodesNum
%    for j=1:vulnerableNum
%        index = size(A,1)+1;
%        A(index,nodesNum*2+edgesNum+vulnerableNum+i) = -allDistances(j,i)-NUMBER_BIGGER_THAN_NETWORK;
%        A(index,nodesNum*2+edgesNum+j) = -1-1/NUMBER_BIGGER_THAN_NETWORK; %TODO Fix sad implementation using floating point arithmetic if using nodes. But N ~< E so using them is better. MATLAB's tolerance for zero is around 10^-14
%    end
%end
%b = [b; (-2*NUMBER_BIGGER_THAN_NETWORK-1)*ones(nodesNum*vulnerableNum,1)];

% Get a different sensor placement solution by preventing the last.
%Aeq(size(Aeq,1)+1,[66]) = [1];
%beq(size(beq,1)+1) = 0; % No others are feasible?

% Implementation using edges TODO There is an inconsistency in these, actuator gives more right answers.
%for j=1:vulnerableNum
%    for i=1:edgesNum
%        index = size(A,1)+1;
%        A(index,nodesNum*2+i) = -distanceEdgesFromVulnerableNodes(j,i) - NUMBER_BIGGER_THAN_NETWORK;
%       A(index,nodesNum*2+edgesNum+j) = -1; 
%    end
%end
%b = [b; (-2*NUMBER_BIGGER_THAN_NETWORK-1)*ones(edgesNum*vulnerableNum,1)];

options = optimoptions('intlinprog','Heuristics', 'round', 'HeuristicsMaxNodes',100);
[x,fval,exitflag,info] = intlinprog(f,intcon,A,b,Aeq,beq,lowerBound,upperBound,options);
if(exist('x')==0)
    return;
end
sensorNodes = find(abs(x(1:nodesNum) -1) < floatTolerance)
% Order of network
actuatorPipes = find(abs(x((nodesNum*2+1):(nodesNum*2+edgesNum)) -1) < floatTolerance);
% Order of IDs
actuatorEdges = pipeIDs(actuatorPipes)
partitionDemand=find(abs(x(nodesNum+1:nodesNum*2) -1) < floatTolerance)';
partitionSource=setdiff(1:nodesNum,partitionDemand);
%disp('Distance to detection for each vulnerable');
%for i=1:vulnerableNum
%    -x(nodesNum*2+edgesNum+j)+NUMBER_BIGGER_THAN_NETWORK
%end
distanceVulnerableToSensors = allDistances(:,sensorNodes)

plotNetwork('bangalore_expanded221.inp',model,nodesNum,edgesNum,vulnerableNodes,vulnerableNum,demandNodes,nodeIDs,pipeStartNodes,pipeEndNodes,adjGraph,incGraph,x);

% Testing the partitioned network
% Remove actuator edges 
adjGraphContained = adjGraph;
adjGraphContained(pipeStartNodes(actuatorPipes),pipeEndNodes(actuatorPipes)) = 0;
adjGraphContained(pipeEndNodes(actuatorPipes),pipeStartNodes(actuatorPipes)) = 0;
tmp2 = graphallshortestpaths(adjGraphContained);
allDistancesContained = tmp2(vulnerableNodes,:);
assert(isequal(size(allDistancesContained), [vulnerableNum nodesNum]));
shortestPathsFromVulnerableNodesContained = min(allDistancesContained);
for i=demandNodes
    assert(shortestPathsFromVulnerableNodesContained(i)>NUMBER_BIGGER_THAN_NETWORK);
end
%BGobj = biograph(adjGraph, [], 'ShowArrows', true);
