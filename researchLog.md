20160202
* Get largest distance that'll be affected from the sensor node distances. This much be smaller than the distances of all actuators.

20160122
Possible directions
* Use shortest paths to maintain distance of actuators being greater than sensors.
* Use the critical sensor for each node, each of which would check with all fo the actuators for conformancy. So a total of VulN*E constraints. Too many.
* Use one sensor only after getting all closest sensors vector after from shortestPathsFromVulnerableNodes.

