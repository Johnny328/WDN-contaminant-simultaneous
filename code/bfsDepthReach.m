function [reach] = bfsDepthReach( A, depth, startNode )
%bfsDepthReach Return the nodes reachable at depth d in a BFS from
%startNode
reach = [];
reach(1,:) = find(A(startNode,:));
for j = 2:depth
    nextLayer = [];
    for i = reach(j-1,:)
        nextLayer = [nextLayer find(A(i,:))];
    end
    tmp = unique([reach(j-1,:) nextLayer]);
    reach(j,1:length(tmp)) = tmp;
end
end