%% Get adjacency matrix from pipes
%% Get data from .inp file
[model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, demandNodes] = getData('bangalore_expanded221.inp');
vulnerableNodes = [vulnerableNodes 19 32 37 39 53 66];

% Use distance from vulnerable nodes to put sensors closer
dist = graphallshortestpaths(adjGraph);
shortestPathsFromVulnerableNodes = min(dist(vulnerableNodes,:));
shortestPathsFromVulnerableNodes(find(shortestPathsFromVulnerableNodes==Inf)) = 100000;
shortestPathsFromVulnerableNodes = shortestPathsFromVulnerableNodes + 0.1; %Use the contant to change weightage

% intcon to make all of them integers
intcon = 1:nodesNum;
% Lower and upper bounds/bianry constraint
lowerBound=zeros(1,nodesNum);
upperBound=ones(1,nodesNum);

%% Sensor placement
% Given vulnerable, find affected for each vulnerable
% 1 step away affected nodes
% affectedN = adjGraph(vulnerableN,:)>=1;
% Find all affected nodes per vulnerable node, each vulnerable node has a row in the A matrix
A = zeros(length(vulnerableNodes),nodesNum);
for i=1:length(vulnerableNodes)
    tmp1 = graphtraverse(adjGraph,vulnerableNodes(i));
    A(i,tmp1) = -1;
end

%Decision variable coefficient vector -- f
f = [shortestPathsFromVulnerableNodes];
%Constraints -Ax >= -b; where (-b)=1
b = -1.*ones(size(A,1),1);

%% Calling intlinprog solver
[xn,fval,exitflag,info] = intlinprog(f,intcon,A,b,[],[],lowerBound,upperBound);
sensorNodes = find(xn);


