%% Get adjacency matrix from pipes
%% Get data from .inp file
[model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, demandNodes] = getWdnData('bangalore_expanded221.inp');
vulnerableNodes = [vulnerableNodes 19 32 37 39 53 66];

%% Sensor placement
% Given vulnerable, find affected for each vulnerable
% 1 step away affected nodes
% affectedN = adjGraph(vulnerableN,:)>=1;
% Find all affected nodes per vulnerable node, each vulnerable node has a row in the A matrix
A = zeros(length(vulnerableNodes),nodesNum);
for i=1:length(vulnerableNodes)
    A(i,graphtraverse(adjGraph,vulnerableNodes(i))) = -1;
end

%Decision variable coefficient vector -- f
f = ones(nodesNum,1)';

%Constraints -Ax >= -b; where (-b)=1
b = -1.*ones(length(vulnerableNodes),1);

%% Calling bintprog solver
options=optimset('Display','iter','NodeDisplayInterval','1','Diagnostics','on');
[xn,fval,exitflag,output] = bintprog(f,A,b,[],[],[],options);
sensorNodes = find(xn);

