% Inspired mostly by Venkat Reddy's implementation.
data=xlsread('data_coord.xlsx','Sheet2');
for tt=1:150
    for ii=tt+1:150
        if data(tt)>data(ii)
            cv=data(tt,:);
            data(tt,:)=data(ii,:);
            data(ii,:)=cv;
        end
    end
end

lbl = cellstr( num2str([1:150]') );

x = data(:,2)'; % Node x coordinates
[cell2mat(cellfun(@str2num,model.pipes.ni,'un',0).')
 y = data(:,3)';  % Node y coordinates
 r = 100; % radius of nodes
 load('Adjacency.mat');
 adj=adjacency;
 adj(12,142)=1;adj(9,10)=1;adj(142,141)=1;adj(141,81)=1;adj(52,108)=1;
 figure;
 axes;
 hold on;
 linewidth = unique(adj(adj>0));
 for il = 1:length(linewidth)
      h = findall(gca, 'type', 'line');
a=findobj(gcf);
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
    gplot(adj == linewidth(il), [x' y']);
    hnew = setdiff(findall(gca, 'type', 'line'), h);
    set(hnew, 'linewidth', 1);
 end
 theta = linspace(0, 2*pi, 500)';
 for k=1:length(partition1)
 xc = bsxfun(@plus, r .* cos(theta), x(partition1(k)));
 yc = bsxfun(@plus, r .* sin(theta), y(partition1(k)));
 patch(xc, yc, 'g');
 end
 for m=1:length(partition2)
%      x1(k)=x(parttion1(k));
 xc = bsxfun(@plus, r .* cos(theta), x(partition2(m)));
 yc = bsxfun(@plus, r .* sin(theta), y(partition2(m)));
 patch(xc, yc, 'r');
 end
 hold on
hold on
 for ii=1:size(adj,1)
     jj=find(adj(ii,:));
     for kk=1:length(jj)
     arrow([x(ii) y(ii)],[(x(ii)+x(jj(kk)))/2,(y(ii)+y(jj(kk)))/2],7,'Baseangle',100,'Tipangle',20);
     end
 end
%   text(x,y,lbl);
 axis equal;
 axis off
