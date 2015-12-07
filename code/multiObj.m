%% Get adjacency matrix from pipes
% Extracts struct from given file
model = epanet_reader4_extract('bangalore_expanded221.inp');
% cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).') outputs a proper
% numeric matrix. The vectors of similar expressions make up the
% corresponding entries (with opposite sign) in the other triangle.
adjGraph = sparse([cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).') cell2mat(cellfun(@str2num,model.pipes.nj,'un',0).')],[cell2mat(cellfun(@str2num,model.pipes.nj,'un',0).') cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).')],[ones(1,model.pipes.npipes) -1.*ones(1,model.pipes.npipes)]);

% Set diagonal to 1
% adjGraph(1 : model.nodes.ntot+1 : model.nodes.ntot*model.nodes.ntot) = 1; 

% Given incidence matrix
incGraph = adj2inc(adjGraph,0);
% Total number of nodes
nodesNum = model.nodes.ntot;
% Vulnerable nodes
vulnerableN = 1:model.nodes.no;

%% Sensor placement
% Given vulnerable, find affected for each vulnerable
% 1 step away affected nodes
% affectedN = adjGraph(vulnerableN,:)>=1;
% Find all affected nodes per vulnerable node, each vulnerable node has a row in the A matrix
A1 = zeros(nodesNum,nodesNum);
for i=1:nodesNum
    A1(i,graphtraverse(adjGraph,i)) = -1;
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

%% Actuator placement
%Objective
f2 = [zeros(1,size(incGraph,2)), ones(1,size(incGraph,1))]';

% Inequality constraint
A2 = [-incGraph -eye(size(incGraph,1))];
b2 = zeros(size(incGraph,1),1);

% Set the partitions of source to 0 and demands to 1
% Equality constraint
tmp = 0;
Aeq2=zeros(0,size(f2,1));
for i=sourceNodes
    tmp = tmp+1;
    Aeq2(tmp,i) = 1;
end
beq2 = zeros(length(sourceNodes),1);
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
b = [b1;b2]
Aeq = [Aeq1 zeros(size(Aeq1,1),size(f2,1)); zeros(size(Aeq2,1),size(f1,1)) Aeq2];
beq = [beq1 beq2];
f = [f1;f2];
intcon = [intcon1 intcon2];
[x,fval,exitflag,info] = intlinprog(f,intcon, A,b,Aeq,beq,lowerBound,upperBound);
partitionDemand=find(x(nodesNum+1:nodesNum*2))';
partitionSource=setdiff(nodesNum+1:nodesNum*2,partitionDemand);