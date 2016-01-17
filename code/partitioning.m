%% Get data from a given input file
[adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, demandNodes] = getData('bangalore_expanded221.inp');

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
lowerBound=zeros(1,nodesNum+edgesNum);
upperBound=ones(1,nodesNum+edgesNum);
%Integer constraint
intcon2 = 1:nodesNum+edgesNum;
[x,fval,exitflag,info] = intlinprog(f2,intcon2,A2,b2,Aeq2,beq2,lowerBound,upperBound);
partitionDemand=find(x(1:nodesNum))';
partitionSource=setdiff(1:nodesNum,partitionDemand);
