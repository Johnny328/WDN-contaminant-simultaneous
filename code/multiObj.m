% Get data from .inp file
[model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, demandNodes] = getData('bangalore_expanded221.inp');
vulnerableNodes = [vulnerableNodes 19 32 37 39 53 66];
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
tmp = 0;
Aeq2=zeros(0,size(f2,1));
for i=vulnerableNodes
    tmp = tmp+1;
    Aeq2(tmp,i) = 1;
end
beq2 = zeros(length(vulnerableNodes),1);
for i=demandNodes
    tmp = tmp+1;
    Aeq2(tmp,i) = 1;
end
beq2 = [beq2; ones(length(demandNodes),1)];

%% Solving combined MILP
% Lower and upper bounds/bianry constraint
lowerBound=zeros(1,nodesNum*2+edgesNum);
upperBound=ones(1,nodesNum*2+edgesNum);
%Integer constraint
intcon2 = nodesNum+1:nodesNum*2+edgesNum;
A = [A1 zeros(size(A1,1),size(f2,1)); zeros(size(A2,1),size(f1,1)) A2];
b = [b1;b2];
Aeq = [Aeq1 zeros(size(Aeq1,1),size(f2,1)); zeros(size(Aeq2,1),size(f1,1)) Aeq2];
beq = [beq1 beq2];
f = [f1;f2];
intcon = [intcon1 intcon2];
[x,fval,exitflag,info] = intlinprog(f,intcon,A,b,Aeq,beq,lowerBound,upperBound);
sensorNodes = find(x(1:nodesNum));
actuatorEdges = find(x((nodesNum*2+1):(nodesNum*2+edgesNum)));
partitionDemand=find(x(nodesNum+1:nodesNum*2))';
partitionSource=setdiff(1:nodesNum,partitionDemand);

plotNetwork('bangalore_expanded221.inp',model,nodesNum,edgesNum,vulnerableNodes,demandNodes,nodeIDs,startNodes,endNodes,adjGraph,incGraph,x);