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
incGraph = adj2inc(adjGraph);
% Total number of nodes
nodesNum = model.nodes.ntot;
% Vulnerable nodes
vulnerableN = find(strcmp(model.nodes.type,'R'));

%% Sensor placement
% Given vulnerable, find affected for each vulnerable
% 1 step away affected nodes
% affectedN = adjGraph(vulnerableN,:)>=1;
% Find all affected nodes per vulnerable node, each vulnerable node has a row in the A matrix
A = zeros(model.nodes.no,model.nodes.ntot);
for i=1:model.nodes.no
    A(i,graphtraverse(adjGraph,i)) = -1;
end

%Decision variable coefficient vector -- f
f = ones(nodesNum,1)';

%Constraints -Ax >= -b; where (-b)=1
b = -1.*ones(length(vulnerableN),1);

%% Calling bintprog solver
options=optimset('Display','iter','NodeDisplayInterval','1','Diagnostics','on');
[xn,fval,exitflag,output] = bintprog(f,A,b,[],[],[],options);
sensorNodes = find(xn);