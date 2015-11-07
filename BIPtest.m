%Given adjacency matrix
adjGraph = sparse([1 1 2 2 2 3 3 4 5],[2 3 4 5 3 4 5 6 6],[2 2 1 1 1 1 1 2 2],6,6);
%TODO Given incidence matrix
incGraph = adj2inc(adjGraph);
%Total number of nodes
nodesNum = 6;
%Vulnerable nodes
vulnerableN = [1,2];
%Given vulnerable, find affected for each vulnerable
%TODO find all directed paths, each has aa row in the  matrix
affectedN = adjGraph(vulnerableN,:)>=1;

%% Sensor placement
%Initial sensors placed, decision variable coefficient -- f
fT = ones(nodesNum,1)';

%Constraints -Ax >= -b; where (-b)=1
b = -1.*ones(length(vulnerableN),1);                                                                                                                                                                                                         
A = zeros(length(vulnerableN),nodesNum);
A(vulnerableN,:) = -1*full(affectedN(vulnerableN,:));

% %% Partitioning and actuator placement problem
% % Minimize J*yT
% J = incGraph;
% yT = ones(length(J),1);
% % Subject to sources and demands in different partitions
% C = zeros(4,length(J));
% C(1,2) = 1;
% C(2,3) = 1;
% C(3,4) = -1;
% C(4,5) = -1;
% C = -1*C;
% d = -1*ones(4,1);

%% Calling bintprog solver
options=optimset('Display','iter','NodeDisplayInterval','1','Diagnostics','on');
[xn,fval,exitflag,output] = bintprog(f,A,b,[],[],[],options);
sensorNodes = find(xn);