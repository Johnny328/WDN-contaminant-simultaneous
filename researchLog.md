20160225
* Removing weight for containment distance. Doesn't change solution at all.
* Rolling back the extra constraints for each edge. Must think of better solution for deamnd to source flows. 
* Implementation: flushing of network at actuators => solution for the problem requiring undirected treatment and extra constraints for each edge.
* Actuators must be between vulnerable and demand & they must also be after the max. distance to sensors. => no need for separete constraint to detect before any demand is contaminated.
* Implemented distanceToDetection spec.

20160216
* Two ways to solve the edge from demand to source partitions: maximize with minimal weight in objective for being in demands, or add another constraint for each edge. Choosing to add constraints.

20160215
0820
* The finding of maximum distance changes the sensor placement(and consequently partitioning) unless it is zero in the objective.
0827
* Computing the transformed variables makes it converge at another optimal solution.
1000
* The formulation does not account properly for zero flows or flows out of a demand partition into source.

1800
* Still not fixed, must subtract NUMBER_BIGGER_THAN_NETWORK from both sides of equation.

0944
* Solved by subtracting one from both sides of constraint.

0936
* Caused by shortestPathsFromVulnerableNodes being zero not satisfying constraints unless max distance is zero.

20160211
* Found major bug making sensors place on vulnerable nodes. 

20160211
* Can't get all the possible optima in MATLAB using inbuilt funcitons.
http://stackoverflow.com/questions/32290770/find-all-answers-to-a-mixed-integer-linear-program-using-branch-and-bound

20160210
* Implementation of node-based placement of actuators done. 

20160202
* Get largest distance that'll be affected from the sensor node distances. This much be smaller than the distances of all actuators.

20160122
Possible directions
* Use shortest paths to maintain distance of actuators being greater than sensors.
* Use the critical sensor for each node, each of which would check with all fo the actuators for conformancy. So a total of VulN*E constraints. Too many.
* Use one sensor only after getting all closest sensors vector after from shortestPathsFromVulnerableNodes.

