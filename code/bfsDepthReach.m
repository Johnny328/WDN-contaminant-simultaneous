function [reach] = bfsDepthReach( A, depth, startNode )
%bfsDepthReach Return the nodes reachable at depth d in a BFS from
%startNode
reach(1,:) = find(A(startNode,:));
for j = 2:depth
    nextLayer = [];
    for i = reach(j-1,:)
        nextLayer = [nextLayer find(A(i,:))];
    end
    reach(j,:) = unique(nextLayer);
end
end

