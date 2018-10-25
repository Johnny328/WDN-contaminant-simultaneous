% Inspired mostly by Venkat Reddy's implementation.
%plotBiograph(filename, model, nodesNum, edgesNum, vulnerableNodes, vulnerableNum, demandNodes, nodeIDs, pipeStartNodes, pipeEndNodes, adjGraph, incGraph, x)
b = biograph(adjGraph);
%for i=1:size(adjGraph,1)
%    b.nodes(i).Shape = 'circle';
%end
h = view(b);
set(0, 'ShowHiddenHandles', 'on');
bgfig = gcf;
c = get(bgfig, 'Children');
%hold on;
for i=1:size(adjGraph,1)
    xcoorID(i) = h.nodes(i).Position(1);
    ycoorID(i) = h.nodes(i).Position(2);
end
set(gcf,'visible','off');
NUMBER_BIGGER_THAN_NETWORK = 10000;
floatTolerance = 1/NUMBER_BIGGER_THAN_NETWORK;
count = 1;
%sensorNodes = find(abs(x(1:nodesNum) -1) < floatTolerance)
% Order of pipeIDs
%actuatorPipes = find(abs(x((nodesNum*2+1):(nodesNum*2+edgesNum)) -1) < floatTolerance);
%partitionDemand=find(abs(x(nodesNum+1:nodesNum*2) -1) < floatTolerance)';
%partitionSource=setdiff(1:nodesNum,partitionDemand);

r = 6; % Radius of drawn nodes
figure;
axes;
hold on;
lines = unique(adjGraph(adjGraph>0));
%for il = 1:length(lines)
%    h = findall(gca, 'type', 'line');
%    a=findobj(gcf);
%    allaxes=findall(a,'Type','axes');
%    alllines=findall(a,'Type','line');
%    alltext=findall(a,'Type','text');
    %gplot(adjGraph == lines(il), [xcoorID' ycoorID']);
    %hnew = setdiff(findall(gca, 'type', 'line'), h);
    %set(hnew, 'linewidth', 1, 'color', 'black');
%end
theta = linspace(0, 2*pi, 500)';
%s = warning('error', 'ARROW:Permission');
%warning('error', 'MATLAB:DELETE:FileNotFound');
for ii=1:size(adjGraph,1)
    jj=find(adjGraph(ii,:));
    for kk=1:length(jj)
        try %TODO check usefulness and effect
        %[xcoorID(ii) ycoorID(ii) 0]
        %[xcoorID(jj(kk)) ycoorID(jj(kk)) 0]
        % TODO arrowheads are skewedand only appear at th ebottom of figure. Rest of params seem fine. CrossDir also seems to work.
        % Providing 3rd dimension in xrood and ycoord makes arrows transpareant, looks ugly
        % Need 10000 length for the first arrow to show up in good scaling
        arrow([xcoorID(ii) ycoorID(ii)],[xcoorID(jj(kk)) ycoorID(jj(kk))],'Length',30);
        catch
            arrow fixlimits;
        end
    end
end
for k=1:length(partitionSource)
    xc = bsxfun(@plus, 0.75*r .* cos(theta), xcoorID(partitionSource(k)));
    yc = bsxfun(@plus, 0.75*r .* sin(theta), ycoorID(partitionSource(k)));
    patch(xc, yc, 'r');
    text(xcoorID(partitionSource(k)) + 10, ycoorID(partitionSource(k)) - 5, num2str(partitionSource(k)))
end
for m=1:length(partitionDemand)
    xc = bsxfun(@plus, 0.75*r .* cos(theta), xcoorID(partitionDemand(m)));
    yc = bsxfun(@plus, 0.75*r .* sin(theta), ycoorID(partitionDemand(m)));
    patch(xc, yc, 'g');
    text(xcoorID(partitionDemand(m)) + 10, ycoorID(partitionDemand(m)) - 5, num2str(partitionDemand(m)))
end
for m=1:length(sensorNodes)
    xc = bsxfun(@plus, r .* cos(theta), xcoorID(sensorNodes(m)));
    yc = bsxfun(@plus, r .* sin(theta), ycoorID(sensorNodes(m)));
    patch(xc, yc-1.5*r, 'y');
end
for k=1:vulnerableNum
    xc = bsxfun(@plus, r .* cos(theta), xcoorID(vulnerableNodes(k)));
    yc = bsxfun(@plus, r .* sin(theta), ycoorID(vulnerableNodes(k)));
    patch(xc+1*r, yc+1*r, 'black');
end
for k=1:length(demandNodes)
    xc = bsxfun(@plus, r .* cos(theta), xcoorID(demandNodes(k)));
    yc = bsxfun(@plus, r .* sin(theta), ycoorID(demandNodes(k)));
    patch(xc+1*r, yc+1*r, 'white');
end
polygonX = [-1 1 -1 1];
polygonY = [1 -1 -1 1];
for k=1:length(actuatorPipes)
    x1 = xcoorID(pipeStartNodes(actuatorPipes(k)));
    y1 = ycoorID(pipeStartNodes(actuatorPipes(k)));
    x2 = xcoorID(pipeEndNodes(actuatorPipes(k)));
    y2 = ycoorID(pipeEndNodes(actuatorPipes(k)));
    c = ([x1 y1]+[x2 y2])/2;
    %d = sqrt(sum(([x1 y1] - [x2 y2]).^2));
    d=6*r/5;
    x3 = d*polygonX+c(1);
    y3 = d*polygonY+c(2);
    patch(x3,y3,'m');
end
%   text(x,y,lbl);
axis equal;
axis off;
hold off;

% Generating legend
types = {'r', 'g', 'y', 'black', 'blue', 'm'};
label = {'Source partition', 'Demand partition', 'Sensor nodes', 'Vulnerable nodes', 'Demand nodes', 'Actuator edges'};
hold on;
for il = 1:length(label)
    hgroup(il) = patch(NaN, NaN, types{il});
end
legend(hgroup,label, 'Location', 'southeast');
