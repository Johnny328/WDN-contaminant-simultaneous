DG = sparse([2 2 3 4 5 5 5 6 7 8 8 9],[1 4 1 5 3 6 7 9 8 1 10 10],true,10,10);
g1 = view(biograph(DG))
from4 = graphtraverse(DG,4);
to1 = graphtraverse(DG',1);
h = intersect(from4,to1)
DG2 = DG(h,h);
g2 = view(biograph(DG2,cellstr(num2str(h'))))