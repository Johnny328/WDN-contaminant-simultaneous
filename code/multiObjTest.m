%% Given adjacency matrix
adjGraph = sparse([1 1 2 2 2 3 3 4 5],[2 3 4 5 3 4 5 6 6],[2 2 1 1 1 1 1 2 2],6,6);
incGraph = adj2inc(adjGraph,0);

% Total number of nodes
nodesNum = 6;
edgesNum = 9;
% Vulnerable nodes
vulnerableN = [1,2];
demandNodes=[6];
sourceNodes=[1 2];

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
intcon=1:nodesNum;
%Equality constraints
Aeq1 = [];
beq1 = [];
[xn,fval,exitflag,output] = intlinprog(f1,intcon,A1,b1,Aeq1,beq1);
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

% Independent solution
% Lower and upper bounds/bianry constraint
lowerBound=zeros(1,nodesNum+edgesNum);
upperBound=ones(1,nodesNum+edgesNum);
%Integer constraint
intcon2 = 1:nodesNum+edgesNum;

[xpositions,fval,exitflag,info] = intlinprog(f2,intcon2,A2,b2,Aeq2,beq2,lowerBound,upperBound);
partition1=find(xpositions(1:nodesNum))';
partition2=setdiff(1:nodesNum,partition1);

% %% Solving combined MILP
% % Lower and upper bounds/bianry constraint
% lowerBound=zeros(1,nodesNum*2+edgesNum);
% upperBound=ones(1,nodesNum*2+edgesNum);
% %Integer constraint
% intcon2 = nodesNum+1:nodesNum*2+edgesNum;
% A = [A1 zeros(size(A1,1),size(f2,1)); zeros(size(A2,1),size(f1,1)) A2];
% Aeq = [Aeq1 zeros(size(Aeq1,1),size(f2,1)); zeros(size(Aeq2,1),size(f1,1)) Aeq2];
% beq = [beq1 beq2];
% f = [f1;f2]
% [xpositions,fval,exitflag,info] = intlinprog(f,[intcon intcon2], A,[b1;b2],[Aeq2],[beq2],lowerBound,upperBound);
% partition4=find(xpositions(nodesNum+1:nodesNum*2))';
% partition3=setdiff(nodesNum+1:nodesNum*2,partition1);