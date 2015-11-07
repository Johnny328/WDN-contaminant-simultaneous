%% Get adjacency matrix from pipes
model = epanet_reader4_extract('bangalore_expanded221.inp');
adj = sparse([cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).') cell2mat(cellfun(@str2num,model.pipes.nj,'un',0).')],[cell2mat(cellfun(@str2num,model.pipes.nj,'un',0).') cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).')],ones(1,model.pipes.npipes*2));
adj(1 : model.nodes.ntot+1 : model.nodes.ntot*model.nodes.ntot) = 1; % Set diagonal to 1

%view(biograph(adj));
% Don't use pipes.nid, it is the position of nodes.
%inc = sparse(cell2mat(cellfun(@str2num,model.pipes.nid,'un',0).')(1,:),cell2mat(cellfun(@str2num,model.pipes.nid,'un',0).'),cell2mat(cellfun(@str2num,model.pipes.length,'un',0).'))