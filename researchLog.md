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

