function [model, adjGraph, incGraph, nodesNum, edgesNum, edgeWeights, vulnerableNodes, demandNodes, pipeIDs, nodeIDs, startNodes, endNodes] = getData(fileName)

% Extracts struct from given file
model = epanet_reader4_extract(fileName);

% Total number of nodes
nodesNum = model.nodes.ntot;
% Number of edges
edgesNum = model.pipes.npipes + model.valves.nv + model.pumps.npumps;

% Vulnerable nodes are the ones of type 'R'
% type='D' => Demands, type='T' => Tanks, type='R' => Reservoirs
vulnerableNodes = find(strcmp(model.nodes.type,'R'));
demandNodes = find(model.nodes.demand>0);
nodeIDs = cell2mat(cellfun(@str2num,model.nodes.id,'un',0).');
vulnerableNodes =  nodeIDs(vulnerableNodes)';
demandNodes = nodeIDs(demandNodes)';

%Weights/lengths of pipes
edgeWeights = eye(edgesNum);

% Get adjacency matrix from pipes
% cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).') outputs a proper
% numeric matrix. The vectors of similar expressions make up the
% corresponding entries (with opposite sign) in the other triangle.
%
% TODO Check if we still need to establish nj->ni. Technically we 
% should establish directed connections for flow AFTER hydraulic 
% simulation, except for valves(which can be done statically).
% Check everytime if negative flow exists, then must switch.
% Or something. This is clearly worng.
adjGraph = sparse([cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).'); cell2mat(cellfun(@str2num,model.valves.ni,'un',0).'); cell2mat(cellfun(@str2num,model.pumps.ni,'un',0).')], [cell2mat(cellfun(@str2num,model.pipes.nj,'un',0).'); cell2mat(cellfun(@str2num,model.valves.nj,'un',0).'); cell2mat(cellfun(@str2num,model.pumps.nj,'un',0).')], ones(1,model.pipes.npipes + model.valves.nv + model.pumps.npumps));
adjGraph(nodesNum,nodesNum) = 0;
negativeEdges = readNegativeFlows('report.out');
pipeIDs = [cell2mat(cellfun(@str2num,model.pipes.id,'un',0).'); cell2mat(cellfun(@str2num,model.valves.id,'un',0).'); cell2mat(cellfun(@str2num,model.pumps.id,'un',0).')];
startNodes = [cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).'); cell2mat(cellfun(@str2num,model.valves.ni,'un',0).'); cell2mat(cellfun(@str2num,model.pumps.ni,'un',0).')];
endNodes = [cell2mat(cellfun(@str2num,model.pipes.nj,'un',0).'); cell2mat(cellfun(@str2num,model.valves.nj,'un',0).'); cell2mat(cellfun(@str2num,model.pumps.nj,'un',0).')];
idxs = arrayfun(@(x)find(pipeIDs==x,1),negativeEdges);
changeToNegativeStartNodes = startNodes(idxs);
changeToNegativeEndNodes = endNodes(idxs);
idx1 = sub2ind(size(adjGraph), changeToNegativeStartNodes, changeToNegativeEndNodes);
idx2 = sub2ind(size(adjGraph), changeToNegativeEndNodes, changeToNegativeStartNodes);
adjGraph(idx1) = 0; %Change to zero for existing, create new edge for the transpose position. Changed from negative edges because of graphtraverse ignoring negative edges.
adjGraph(idx2) = 1;
% Get incidence matrix
incGraph = adj2inc(adjGraph);

