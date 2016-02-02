% Get data from .inp file
[adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, demandNodes, pipeIDs, nodeIDs, startNodes, endNodes] = getData('bangalore_expanded221.inp');
vulnerableNodes = [vulnerableNodes 19 32 37 39 53 66];
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
distanceEdgesFromVulnerableNodes = shortestPathsFromVulnerableNodes(startNodes); 

%% Solving combined MILP
% Lower and upper bounds/bianry constraint
lowerBound=zeros(1,nodesNum*2+edgesNum);
upperBound=ones(1,nodesNum*2+edgesNum);
%Integer constraint
intcon2 = nodesNum+1:nodesNum*2+edgesNum;

f3 = [1 ones(nodesNum,1)];


A = [A1 zeros(size(A1,1), size(f2,1)+size(f3,1)); zeros(size(A2,1), size(f1,1)+size(f3,1)) A2];
b = [b1;b2];
Aeq = [Aeq1 zeros(size(Aeq1,1), size(f2,1)+size(f3,1)); zeros(size(Aeq2,1), size(f1,1)+size(f3,1)) Aeq2];
beq = [beq1 beq2];
f = [f1;f2;f3];
intcon = [intcon1 intcon2];

% Use equality constraints to force sensor nodes(and all nodes at or lesser distance from vulnerable nodes) to be in the source
% partition. Observability => all are critical, can make another objective
% for identifiability easily.
for i=1:nodesNum
    index = size(A,1)+1;
    A(index,i) = shortestPathsFromVulnerableNodes(i);
    A(index,1+nodesNum*2+edgesNum) = -1;
end
b = [b; zeros(nodesNum,1)];

for i=1:nodesNum
    index = size(A,1)+1;
    A(index,i) = 1;
    A(index,1+nodesNum*2+edgesNum+i) = -1/1000000;
end
b = [b; zeros(nodesNum,1)];

for i=1:nodesNum
    index = size(A,1)+1;
    A(index,i+nodesNum*2+edgesNum+1) = distanceEdgesFromVulnerableNodes(i);
    A(index,1+nodesNum*2+edgesNum) = -1; %TODO Sad implementation using floating point arithmetic if using nodes. But N <~ E so using them is better.
end
b = [b; zeros(edgesNum,1)];

[x,fval,exitflag,info] = intlinprog(f,intcon,A,b,Aeq,beq,lowerBound,upperBound);
%isempty(x,[]); TODO
sensorNodes = find(x(1:nodesNum));
actuatorEdges = find(x((nodesNum*2+1):(nodesNum*2+edgesNum)));
partitionDemand=find(x(nodesNum+1:nodesNum*2))';
partitionSource=setdiff(1:nodesNum,partitionDemand);
