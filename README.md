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

### Done
containment_attackAtOnce_9V genration missing, legend. Done, same as testContainment 2nd test
zoneContainment_9sources - check antialiasing for the generated file in final PDF. Done, no anti-aliasing in PDF.
containment_9sources_1downstreamSourceEach - verify, check anti aliasing. Done, Generated zoneContainment_1downstreameach_legend
multiobj_indep generation missing, legend. Done, generated exact graph with legend
