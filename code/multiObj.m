% Note that this isn't really multi objective optimization. I have no idea why I named it thus, even in hindsight. Possibly just didn't relate multiobjective => solution requires a pareto front

if(exist('WdnPath'))
    % Get data from .inp file
    [model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, vulnerableNum, demandNodes, pipeIDs, nodeIDs, pipeStartNodes, pipeEndNodes] = getWdnData(WdnPath);
elseif(exist('adjGraph'))
    %% Given adjacency matrix
    %adjGraph = sparse([1 1 2 2 2 3 3 4 5 6],[2 3 4 5 3 4 5 6 6 7],[1 1 1 1 1 1 1 1 1 1],7,7);
    incGraph = adj2inc(adjGraph,0);
    % Total number of nodes
    nodesNum = size(adjGraph,1);
    edgesNum = size(incGraph,1);
    % Vulnerable nodes
    %vulnerableNodes = [1,2,4,5];%Test failed, this should've lead to sensor at 6 and actuator after it. Something wrong with shortestPathsFromVulnerableNodes code.
    %demandNodes = [7];
    %Weights/lengths of pipes
    edgeWeights = eye(edgesNum);
    for i=1:size(incGraph,1)
        pipeStartNodes(i) = find(incGraph(i,:)>0);
        pipeEndNodes(i) = find(incGraph(i,:)<0);
    end
    pipeIDs = 1:size(incGraph,1);
    vulnerableNum = size(vulnerableNodes,2);
else
    % Get data from .inp file
    [model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, vulnerableNum, demandNodes, pipeIDs, nodeIDs, pipeStartNodes, pipeEndNodes] = getWdnData('bangalore_expanded221.inp');
end
if(exist('vulnerableN'))
    vulnerableNodes = vulnerableN;
    vulnerableNum = length(vulnerableNodes);
end
if(exist('demandN'))
    demandNodes = demandN;
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
beq2 = zeros(vulnerableNum,1);
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
beq = [beq1;beq2];
f = [f1;f2];
intcon = [intcon1 intcon2];
[x,fval,exitflag,info] = intlinprog(f,intcon,A,b,Aeq,beq,lowerBound,upperBound);
sensorNodes = find(x(1:nodesNum));
actuatorEdges = find(x((nodesNum*2+1):(nodesNum*2+edgesNum)));
partitionDemand=find(x(nodesNum+1:nodesNum*2))';
partitionSource=setdiff(1:nodesNum,partitionDemand);

if(exist('model'))
    plotNetwork('bangalore_expanded221.inp',model,nodesNum,edgesNum,vulnerableNodes,vulnerableNum,demandNodes,nodeIDs,pipeStartNodes,pipeEndNodes,adjGraph,incGraph,x);
else
    actuatorPipes = actuatorEdges
    plotBiograph
end
