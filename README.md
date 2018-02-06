Research files and code dealing with simultaneous sensor and actuator placement for contaminant detection, part of my undergrad thesis

*.inp are genrally best viewed with a local EPANET installation, here is a web version: http://epanet.de/js/index.html

### License
CC-BY 4.0 license, unless otherwise overridden.

## Execution
Entry points for various problem descriptions:
compromisedContainment.m
zoneContainment.m
multiObj.m

Generating files for reproducing results:
testZoneContainment.m
testContainment.m
testMultiObj.m


## TODO
multiobj_indep generation missing, legend.
containment_attackAtOnce_9V genration missing, legend.
zoneContainment_9sources - check antialiasing for the generated file in final PDF
containment_9sources_1downstreamSourceEach - verify, check anti aliasing
