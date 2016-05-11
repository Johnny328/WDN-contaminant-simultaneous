clear all
demandN = [6 7];
tolerance = 10^-4;
vulnerableN = [1 2];
adjGraph = sparse([1 1 2 3 2 3 3 4 5],[2 3 4 5 3 6 5 6 7],[1 1 1 1 1 1 1 1 1],7,7);
%multiObjTest

zoneContainment

