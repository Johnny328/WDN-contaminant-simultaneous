### 20160421
* Fixed the brute force implementation. Various errors.

### 20160420
* Brute Force: implementation stuck in non-feasibility errors in equality.
* Way to implement distance: store the relevant critical vulN in a d.v, then use only those sensors for those vulN -- 1 per vulN. Can find thier distance exactly, because it's only one.

### 20160419
* Fixed no feasible solution in node imple.: Part of two bugs, actuator zeroes aren't handled, node the inequality isn't handled properly.
* Zero in the dj will cause a meltdown of inequality(dj < Dij) logic 5 lines below.

### 20160418
* FIXed different solutions from edge and node contraints.
* BUG from 20160416, more nodes being compromised isn't necessarily a bad thing. There's a reason why they're not distinguished in the objective function.
But it isn't just more nodes being compromised. It is a situation where the real nodes *wont* be compromised, but are shown as compromised. 
With constraints of total number of affected nodes, it could cause unintended effects. Delaying this until later.

### 20160417
* Implemnting constraints with large blowup in decision variables.

### 20160416
* Evidence for "minimization will not work": The test cases with [131 20] in testZoneContainment will produce higher values of the decision variable (M-dj) than from sensor distances constraints. They *can't* go any lower because the partitioning problem prevents prevents that.
* Reasoning for why the edge based formulation produces "No feasible solutions": The forcing of distances does not handle zeroes in decision variables.
* BUG: Test case with [131 20]; Node 19 is put into source partition because wherever the break occurs from 19 to 134, there's no distinction w.r.t the objective, contraints. 
Possible solutions: Source partition only if affected.

### 20160414
* Added a demand node of 81, this node lies behind a zero flow edge; doesn't affect anything.
* Fixed yesterday's BUG.

### 20160412
* The enforcing of 1 of all the constraints on nodes will take too many decision variables -- one for each constraint.
* As will perhaps implementing it as `w = 0 = product(All differences)` and linearizing it i.e. ensuring the product of the difference between distances to sensors and the minimum distance is 0.
* One other way is to use the partition of a node as a heuristic to discard the equivalence condition.
* BUG: Actuators not getting placed in spite of change in partition across an edge.First test in testZoneContainment.m, assertion fails.

### 20160404
* http://www.ie.boun.edu.tr/~taskin/pdf/IP_tutorial.pdf, gives possible solution.

### 20160403
* Yet another: the actuator implementation seems to be better, gives the correct result of no feasible solutions, given the below bug.

### 20160402
* Another bug -- strategies still allow actuators before detection.

### 20160330
* Fixed bug. Using another set of constraints to constrain it to take the value of the minimum sensor.

### 20160329
* Bug of sensor distances not getting reflected into the minimum sensor distance variables. The variables when constrained by the actuator placement, even with their inclusion in the objective will take higher values than the current sensor placement. This essentially allows the sensors to go wherever, breaking the formulation.
* Need a constraint to force variable to the maximum, and not go higher.

### 20160323
* Fixed test framework, added Case 3 results to report. Fixed wrong formulation of all-vulnerable containment in report.

### 20160322
* Improved report to reflect published references, restructured data into scenarios.

### 20160315
* Implemented containment distance for each sensor. Zone of containment for each vulnerable node.

### 20160314
* max . max formulation makes it impossible to deal with large networks -- the largest distance from vulnerable might be greater than network sizes.

### 20160311
* Fixed bug where b2 wasn't as long as size(incGraph,1)*2.
* Used to be: max(over sens) . min(over vulN) A -- leads to error found on 20160303
* Must be: max(over vulN) . min(over sensors) A
* Can be, current: (not the best possible, but still valid)
    max(over sens) . max(over vulN) A -- Gives no solution with 9 vulnerable nodes.

### 20160310
* Abandoned the case of single/subset vulnerable nodes contamination.
* Working on formulation for each vulnerable node separately, enforcing containment zones. 

20160303
* Found error of some vulnerable nodes on getting contaminated solo might reach demand (and actuator) before sensor.

20160229
* Manual generation of incidence matrix to keep track of edges.
* Adding undirected containment because of bad results.
* Added testing framework.

20160225
* Removing weight for containment distance. Doesn't change solution at all.
* Rolling back the extra constraints for each edge. Must think of better solution for demand to source flows. 
* Implementation: flushing of network at actuators => solution for the problem requiring undirected treatment and extra constraints for each edge.
* Actuators must be between vulnerable and demand & they must also be after the max. distance to sensors => no need for separete constraint to ensure detection before any demand is contaminated.
* Implemented distanceToDetection spec.

### 20150217
#### 0600
* Started work on implementing each vulnerable node having its own minimum distance.

### 20160216
#### 1000
* Edge based implementation leads to same results.
#### 0900
* Constraints lead to unnecessary actuators on flows from demand to source.
#### 0700
* Two ways to solve the edge from demand to source partitions: maximize with minimal weight in objective for being in demands, or add another constraint for each edge. Choosing to add constraints.

### 20160215
1000
* The formulation does not account properly for zero flows or flows out of a demand partition into source.
0827
* Computing the transformed variables makes it converge at another optimal solution.
0820
* The finding of maximum distance changes the sensor placement(and consequently partitioning) unless it is zero in the objective.

### 20160212
#### 1800
* Still not fixed, must subtract NUMBER_BIGGER_THAN_NETWORK from both sides of equation.
#### 0944
* Solved by subtracting one from both sides of constraint.
#### 0936
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

