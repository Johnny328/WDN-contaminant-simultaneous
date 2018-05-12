% Create a directed graph with 6 nodes
cm = sparse([1 1 2 2 3 3 4 5],[2 3 4 5 4 5 6 6],[2 2 1 1 1 1 2 2],6,6);
% Call the maximum flow algorithm between 1 and 6
[M,F,K] = graphmaxflow(cm,1,6)
% View graph with original flows
h = view(biograph(cm,[],'ShowWeights','on'))
% View graph with actual flows
view(biograph(F,[],'ShowWeights','on'))
% Show in the original graph one solution of the mincut problem
set(h.Nodes(K(1,:)),'Color',[1 0 0])