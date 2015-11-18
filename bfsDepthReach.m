function [reach] = bfsDepthReach( A, depth, startNode )
%bfsDepthReach Return the nodes reachable at depth d in a BFS from
%startNode
reach(1,:) = find(A(startNode,:));
for j = 2:depth
    tmp = [];
    for i = reach(j-1,:)
        tmp = [tmp find(A(i,:))];
    end
    reach(j,:) = unique(tmp);
end
end

