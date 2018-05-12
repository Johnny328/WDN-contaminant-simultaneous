function [reach] = timeReach( A, timeElapsed, startNode )
%timeReach Return the time to reach nodes for each node which is going to
%be reached.
% reach - Structure. nodes contains a vector of nodes which can be reached

% Initial reach structure, first layer of nodes accessible from the
% startNode.

%TODO
reach.nodes = 1:length(A);

reach.timeElapsed = zeros(1,length(reach.queue));
reach.leastParent = ones(1,length(reach.queue))*startNode;
reach.reached = zeros(1,length(reach.queue));
% Queue to be processed.
reach.queue = length(A(startNode,:));
% Iterating over each of them to update the flow reaches.
for j = 1:length(reach.queue)
    % If timeElapsed is greater than the time to the node from the
    % previous one, move on to the next layer.
    if(reach.queue(j).timeElapsed + A(reach.leastParent(j),reach.queue(j)) < timeElapsed)
        reach.timeElapsed(j) = reach.timeElapsed(j) + A(reach.leastParent(j),reach.queue(j));
        % Set node as reached
        reach.reached(j) = 1;
        
        % Find the next layer of nodes
        nextLayer = find(A(reach.queue(j))>0);
        
        % They are new nodes: Add them to queue
        %uniqueNewNodes = unique([reach.queue(j+1:end) nextLayer]);
        %timeElapsed = ones(1,length(uniqueNewNodes))*reach.timeElapsed(j)
        %newNodes = length(uniqueNewNodes) - length(reach.queue);
        %reach.queue = uniqueNewNodes;
        positions = findComplicated(reach.queue, nextLayer)
        for k=1:length(positions)
                % Already processed: add to queue 
                if(position<j)
                    
            % if more time than the one in queue
            if(reach.timeElapsed(j) > reach.timeElapsed(reach.leastParent(positions(k))))
                    reach.timeElapsed(positions(k)) = max(reach.timeElapsed(j),reach.timeElapsed(positions(k)))
                    reach.leastParent(positions(k)) = j;
                    reach.queue = [reach.queue reach.queue(positions(k))]
                
                end
                else
                % Already in the queue but not processed: Update nodes in queue
                    reach.timeElapsed(positions(k)) = max(reach.timeElapsed(j),reach.timeElapsed(positions(k)))
                    reach.leastParent(positions(k)) = j;
            
            end
        end
    else
        reach.reached(j) = (timeElapsed - reach.timeElapsed(j))/A(reach.leastParent(j),reach.queue(j));
        reach.timeElapsed(j) = timeElapsed;
    end
end
end