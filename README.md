Research files and code dealing with simultaneous sensor and actuator placement for contaminant detection, part of my undergrad thesis

\*.inp are genrally best viewed with a local EPANET installation, here is a web version: http://epanet.de/js/index.html

### License
CC-BY 4.0 license, unless otherwise overridden.

## Execution
Implementations for various problem descriptions (scenarios 1,2,3):
multiobj.m
containment.m
zoneContainment.m

Entry points for generating images, reproducing results (scenarios 1,2,3):
testMultiObj.m
testContainment.m
testZoneContainment.m

## Description of scenarios implemented

### Notes
compromisedContainment.m was built after containment. Solves similar scenario that zone containment does. My best guess in retrospect is that 'compromised' refers to a bad algorithm.
Solved: git logs say its sole purpose is to reproduce/validate Palleti 2017's results

bfsDepthReach.m: Implemented reachable nodes with BFS, unused
BTPtest.m: bintprog solver, only sensor placement
