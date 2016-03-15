% Inspired mostly by Venkat Reddy's implementation.
function plotNetwork(filename, model, nodesNum, edgesNum, vulnerableNodes, vulnerableNum, demandNodes, nodeIDs, startNodes, endNodes, adjGraph, incGraph, x)

xcoor = model.nodes.xcoor;
ycoor = model.nodes.ycoor;
count = 1;
for i=1:nodesNum
    xcoorID(nodeIDs(i)) = xcoor(i);
    ycoorID(nodeIDs(i)) = ycoor(i);
end
sensorNodes = find(x(1:nodesNum));
actuatorEdges = find(x((nodesNum*2+1):(nodesNum*2+edgesNum)));
partitionDemand=find(x(nodesNum+1:nodesNum*2))';
partitionSource=setdiff(1:nodesNum,partitionDemand);

r = 100; % Radius of drawn nodes
figure;
axes;
hold on;
linewidth = unique(adjGraph(adjGraph>0));
for il = 1:length(linewidth)
    h = findall(gca, 'type', 'line');
    a=findobj(gcf);
    allaxes=findall(a,'Type','axes');
    alllines=findall(a,'Type','line');
    alltext=findall(a,'Type','text');
    gplot(adjGraph == linewidth(il), [xcoorID' ycoorID']);
    hnew = setdiff(findall(gca, 'type', 'line'), h);
    set(hnew, 'linewidth', 1, 'color', 'black');
end
theta = linspace(0, 2*pi, 500)';
for k=1:length(partitionSource)
    xc = bsxfun(@plus, r .* cos(theta), xcoorID(partitionSource(k)));
    yc = bsxfun(@plus, r .* sin(theta), ycoorID(partitionSource(k)));
    patch(xc, yc, 'r');
end
for m=1:length(partitionDemand)
     %      x1(k)=x(parttion1(k));
     xc = bsxfun(@plus, r .* cos(theta), xcoorID(partitionDemand(m)));
     yc = bsxfun(@plus, r .* sin(theta), ycoorID(partitionDemand(m)));
     patch(xc, yc, 'g');
 end
 %for m=1:length(sensorNodes)
 %    xc = bsxfun(@plus, r .* cos(theta), xcoorID(sensorNodes(m)));
 %    yc = bsxfun(@plus, r .* sin(theta), ycoorID(sensorNodes(m)));
 %    patch(xc, yc, 'y');
 %end
 for k=1:vulnerableNum
     xc = bsxfun(@plus, r .* cos(theta), xcoorID(vulnerableNodes(k)));
     yc = bsxfun(@plus, r .* sin(theta), ycoorID(vulnerableNodes(k)));
     patch(xc, yc, 'black');
 end
 for k=1:length(demandNodes)
     xc = bsxfun(@plus, r .* cos(theta), xcoorID(demandNodes(k)));
     yc = bsxfun(@plus, r .* sin(theta), ycoorID(demandNodes(k)));
     patch(xc, yc, 'white');
 end
 hold on
 hold on
 for ii=1:size(adjGraph,1)
     jj=find(adjGraph(ii,:));
     for kk=1:length(jj)
         %arrow([xcoorID(ii) ycoorID(ii)],[(xcoorID(ii)+xcoorID(jj(kk)))/2,(ycoorID(ii)+ycoorID(jj(kk)))/2],7,'Baseangle',100,'Tipangle',20);
     end
 end
 %   text(x,y,lbl);
 axis equal;
 axis off;
 hold off;
