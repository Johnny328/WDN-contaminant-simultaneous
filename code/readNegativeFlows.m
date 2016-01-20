function negativeEdges = readNegativeFlows(file)
fileID = fopen(file,'r');
textscan(fileID,'%s',17,'Delimiter','\n');
i=1;
negativeEdges = zeros(41,1);
while (i<=41)
    negativeEdges(i) = fscanf(fileID, '%d',1);
    fgetl(fileID);
    i=i+1;
end