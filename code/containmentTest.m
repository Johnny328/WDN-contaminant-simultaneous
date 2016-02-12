
%% Given adjacency matrix
adjGraph = sparse([1 1 2 2 2 3 3 4 5 6],[2 3 4 5 3 4 5 6 6 7],[1 1 1 1 1 1 1 1 1 1],7,7);
incGraph = adj2inc(adjGraph,0);
% Total number of nodes
nodesNum = size(adjGraph,1);
edgesNum = size(incGraph,1);
% Vulnerable nodes
vulnerableNodes = [1,2,4,5];%Test failed, this should've lead to sensor at 6 and actuator after it. Something wrong with shortestPathsFromVulnerableNodes code.
demandNodes = [7];
sourceNodes = [1 2];
%Weights/lengths of pipes
edgeWeights = eye(edgesNum);
NUMBER_BIGGER_THAN_NETWORK = 10000;

%% Sensor placement
% Given vulnerable, find affected for each vulnerable
% 1 step away affected nodes
% affectedN = adjGraph(vulnerableN,:)>=1;
% Find all affected nodes per vulnerable node, each vulnerable node has a row in the A matrix
A1 = zeros(length(vulnerableNodes),nodesNum);
for i=1:length(vulnerableNodes)
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
Aeq1 = [];
beq1 = [];
% Forcing sensors at these point to see obj. fun. value. As it turns out, not feasible.
%Aeq1i = 0;
%Aeq1 = zeros(0,size(f1,1));
%for i=[41,69,56]
%    Aeq1i = Aeq1i + 1;
%    Aeq1(Aeq1i,i) = 1;
%end
%beq1 = ones(3,1);

%% Actuator placement %Inspired by Venkat Reddy's implementation of partitioning.
%Objective
f2 = [zeros(1,size(incGraph,2)), ones(1,size(incGraph,1))]';

% Inequality constraint
A2 = [-incGraph -eye(size(incGraph,1))*edgeWeights];
b2 = zeros(size(incGraph,1),1);

% Set the partitions of source to 0 and demands to 1
% Equality constraint
Aeq2i = 0;
Aeq2 = zeros(0,size(f2,1));
for i=vulnerableNodes
    Aeq2i = Aeq2i+1;
    Aeq2(Aeq2i,i) = 1;
end
beq2 = zeros(length(vulnerableNodes),1);
for i=demandNodes
    Aeq2i = Aeq2i+1;
    Aeq2(Aeq2i,i) = 1;
end
beq2 = [beq2; ones(length(demandNodes),1)];

tmp2 = graphallshortestpaths(adjGraph);
allDistances = tmp2(vulnerableNodes,:);
assert(isequal(size(allDistances), [length(vulnerableNodes) nodesNum]));
shortestPathsFromVulnerableNodes = min(allDistances);
tmp3 = sort(shortestPathsFromVulnerableNodes);
maxDistance = tmp3(end-1);
shortestPathsFromVulnerableNodes(find(shortestPathsFromVulnerableNodes==Inf)) = NUMBER_BIGGER_THAN_NETWORK;
%distanceEdgesFromVulnerableNodes = shortestPathsFromVulnerableNodes(startNodes); 

%% Solving combined MILP
%Integer constraint
intcon2 = nodesNum+1:nodesNum*2+edgesNum;

% New decision variables for transformed space.
%f3 = [1/NUMBER_BIGGER_THAN_NETWORK/1000000;-1/NUMBER_BIGGER_THAN_NETWORK/1000000.*ones(nodesNum,1)];
f3 = [1/NUMBER_BIGGER_THAN_NETWORK/1000000; zeros(nodesNum,1)];
intcon3 = (nodesNum*2+edgesNum+1):(nodesNum*2+edgesNum+1+nodesNum);

% Lower and upper bounds/bianry constraint
lowerBound = [zeros(1,nodesNum*2+edgesNum) 0 ones(1,nodesNum)];
upperBound = [ones(1,nodesNum*2+edgesNum) NUMBER_BIGGER_THAN_NETWORK NUMBER_BIGGER_THAN_NETWORK.*ones(1,nodesNum)];

A = [A1 zeros(size(A1,1),size(f2,1)+size(f3,1)); zeros(size(A2,1),size(f1,1)) A2 zeros(size(A2,1),size(f3,1))];
b = [b1;b2];
Aeq = [Aeq1 zeros(size(Aeq1,1),size(f2,1)+size(f3,1)); zeros(size(Aeq2,1),size(f1,1)) Aeq2 zeros(size(Aeq2,1),size(f3,1))];
beq = [beq1;beq2];
f = [f1;f2;f3];
intcon = [intcon1 intcon2 intcon3];

% Use inequality constraints to force sensor nodes(and all nodes at or lesser distance from vulnerable nodes) to be in the source
% partition. Observability => all are critical, can make another objective
% for identifiability easily.

% Get max sensor distance
for i=1:nodesNum
    index = size(A,1)+1;
    A(index,i) = shortestPathsFromVulnerableNodes(i);
    A(index,1+nodesNum*2+edgesNum) = -1;
end
b = [b; zeros(nodesNum,1)];

% Make the partition vector 1 for demand partition and NUMBER_BIGGER_THAN_NETWORK for source.
% Decision variables bounds [1, NUMBER_BIGGER_THAN_NETWORK]. Don't maximize. 
b = [b; zeros(nodesNum*2,1)];
for i=1:nodesNum
    index = size(A,1)+1;
    A(index,i+nodesNum) = -NUMBER_BIGGER_THAN_NETWORK;
    A(index,1+nodesNum*2+edgesNum+i) = -1;
    b(index) = -NUMBER_BIGGER_THAN_NETWORK; 
    index = size(A,1)+1;
    A(index,i+nodesNum) = NUMBER_BIGGER_THAN_NETWORK-1;
    A(index,1+nodesNum*2+edgesNum+i) = 1;
    b(index) = NUMBER_BIGGER_THAN_NETWORK; 
end

% Force all partitioning to happen after the distance.
for i=1:nodesNum
    index = size(A,1)+1;
    %A(index, nodesNum+i) = 
    A(index,1+nodesNum*2+edgesNum+i) = -shortestPathsFromVulnerableNodes(i)-NUMBER_BIGGER_THAN_NETWORK; %Not 1, it must compete with 1+1/NUMBER_BIGGER_THAN_NETWORK
    A(index,1+nodesNum*2+edgesNum) = 1+1/NUMBER_BIGGER_THAN_NETWORK; %TODO Fix sad implementation using floating point arithmetic if using nodes. But N ~< E so using them is better. MATLAB's tolerance for zero is around 10^-14
end
b = [b; -NUMBER_BIGGER_THAN_NETWORK*ones(nodesNum,1)];

% Implementation using edges
%for i=1:edgesNum
%    index = size(A,1)+1;
%    A(index,i+nodesNum*2) = -distanceEdgesFromVulnerableNodes(i);
%    A(index,1+nodesNum*2+edgesNum) = 1; 
%end
%b = [b; zeros(edgesNum,1)];

[x,fval,exitflag,info] = intlinprog(f,intcon,A,b,Aeq,beq,lowerBound,upperBound);
%isempty(x,[]); TODO
sensorNodes = find(x(1:nodesNum));
actuatorEdges = find(x((nodesNum*2+1):(nodesNum*2+edgesNum)));
partitionDemand=find(x(nodesNum+1:nodesNum*2))';
partitionSource=setdiff(1:nodesNum,partitionDemand);
