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
lines = unique(adjGraph(adjGraph>0));
for il = 1:length(lines)
    h = findall(gca, 'type', 'line');
    a=findobj(gcf);
    allaxes=findall(a,'Type','axes');
    alllines=findall(a,'Type','line');
    alltext=findall(a,'Type','text');
    %gplot(adjGraph == lines(il), [xcoorID' ycoorID']);
    %hnew = setdiff(findall(gca, 'type', 'line'), h);
    %set(hnew, 'linewidth', 1, 'color', 'black');
end
theta = linspace(0, 2*pi, 500)';
%s = warning('error', 'ARROW:Permission');
%warning('error', 'MATLAB:DELETE:FileNotFound');
for ii=1:size(adjGraph,1)
    jj=find(adjGraph(ii,:));
    for kk=1:length(jj)
        %try %TODO check usefulness and effect
         arrow([xcoorID(ii) ycoorID(ii)],[xcoorID(jj(kk)),ycoorID(jj(kk))],'Baseangle',80,'Tipangle',17,'Width',0.3,'Length',8);
         %catch
      %       arrow fixlimits;
       %  end
    end
end
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
for m=1:length(sensorNodes)
    xc = bsxfun(@plus, r .* cos(theta), xcoorID(sensorNodes(m)));
    yc = bsxfun(@plus, r .* sin(theta), ycoorID(sensorNodes(m)));
    patch(xc, yc-150, 'y');
end
for k=1:vulnerableNum
    xc = bsxfun(@plus, r .* cos(theta), xcoorID(vulnerableNodes(k)));
    yc = bsxfun(@plus, r .* sin(theta), ycoorID(vulnerableNodes(k)));
    patch(xc+100, yc+100, 'black');
end
for k=1:length(demandNodes)
   xc = bsxfun(@plus, r .* cos(theta), xcoorID(demandNodes(k)));
   yc = bsxfun(@plus, r .* sin(theta), ycoorID(demandNodes(k)));
   patch(xc+100, yc+100, 'white');
end
%   text(x,y,lbl);
axis equal;
axis off;
hold off;
