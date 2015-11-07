function [model2]=epanet_reader4_extract(FileName_INP)
%  FUNCTION [model2,FileName1,status01]=epanet_reader4_extract(FileName1)
%   - Read data from .INP file form EPANET 2.0
%   - The file selection is made using uigetfile
%
% Input Arguments
% FileName : Name of the file to upload
%
% Output Arguments
%   model2 : contains the nodes, pipes, valves and pumps data located in the
%            INP file as an structure
% 
% Issues to solve:
%  - Can not load if the fields of the INP file after [***] include a
%    description "; abracadabra"
%  - Can not retrieve the patterns yet
%  - Can not retrieve the curves yet
%  - Can not retrieve the Options and times
%  - Can not retrieve water quality parameters
%  - Given that the topology does not require the internal vertex
%
%  Developed by : Mario Castro Gama
%                 MSc. Hydroinformatics
%         email : m.castrogama@unesco-ihe.org
%  Last update  : 2015.01.30
%



  % LOAD INP INTO VARIABLE
  txt = dataread('file', FileName_INP, '%s', 'delimiter', '\n','bufsize',1500000);
  ntxt=length(txt);
  disp(['   File has ',num2str(ntxt),' lines']);

  % create the output variable
  model2=[];
  model2.file=FileName_INP;
  model2.loc=[];
  model2.nodes={}; % includes tanks and reservoirs.
  model2.pipes={};
  model2.pumps={};

  titlii=find(strcmp(txt,'[TITLE]')==1);      model2.loc.titlii=titlii;
  juncii=find(strcmp(txt,'[JUNCTIONS]')==1);  model2.loc.juncii=juncii;
  reseii=find(strcmp(txt,'[RESERVOIRS]')==1); model2.loc.reseii=reseii;
  tankin=find(strcmp(txt,'[TANKS]')==1);      model2.loc.tankin=tankin;
  pipeii=find(strcmp(txt,'[PIPES]')==1);      model2.loc.pipeii=pipeii;
  pumpii=find(strcmp(txt,'[PUMPS]')==1);      model2.loc.pumpii=pumpii;
  valvii=find(strcmp(txt,'[VALVES]')==1);     model2.loc.valvii=valvii;
  tagsii=find(strcmp(txt,'[TAGS]')==1);       model2.loc.tagsii=tagsii;
  demaii=find(strcmp(txt,'[DEMANDS]')==1);    model2.loc.demaii=demaii;
  statii=find(strcmp(txt,'[STATUS]')==1);     model2.loc.statii=statii;
  pattii=find(strcmp(txt,'[PATTERNS]')==1);   model2.loc.pattii=pattii;
  curvii=find(strcmp(txt,'[CURVES]')==1);     model2.loc.curvii=curvii;
  contii=find(strcmp(txt,'[CONTROLS]')==1);   model2.loc.contii=contii;
  ruleii=find(strcmp(txt,'[RULES]')==1);      model2.loc.ruleii=ruleii;
  enerii=find(strcmp(txt,'[ENERGY]')==1);     model2.loc.enerii=enerii;
  emitii=find(strcmp(txt,'[EMITTERS]')==1);   model2.loc.emitii=emitii;
  qualii=find(strcmp(txt,'[QUALITY]')==1);    model2.loc.qualii=qualii;
  sourii=find(strcmp(txt,'[SOURCES]')==1);    model2.loc.sourii=sourii;
  reacii=find(strcmp(txt,'[REACTIONS]')==1);  model2.loc.reacii=reacii;
  mixnii=find(strcmp(txt,'[MIXING]')==1);     model2.loc.mixnii=mixnii;
  timeii=find(strcmp(txt,'[TIMES]')==1);      model2.loc.emitii=timeii;
  repoii=find(strcmp(txt,'[REPORT]')==1);      model2.loc.repoii=repoii;
  optnii=find(strcmp(txt,'[OPTIONS]')==1);     model2.loc.optnii=optnii;
  coorii=find(strcmp(txt,'[COORDINATES]')==1); model2.loc.coorii=coorii;
  vertii=find(strcmp(txt,'[VERTICES]')==1);    model2.loc.vertii=vertii;
  lablii=find(strcmp(txt,'[LABELS]')==1);      model2.loc.lablii=lablii;
  backii=find(strcmp(txt,'[BACKDROP]')==1);    model2.loc.backii=backii;
  endii =find(strcmp(txt,'[END]')==1);         model2.loc.endii=endii;

% get the options of calculation
% options.units       = txt{optnii +  2};
% options.headloss    = txt{optnii +  4};
% options.specgravity = txt{optnii +  7};
% options.viscosity   = txt{optnii +  9};
% options.trials      = txt{optnii + 11};
% options.accuracy    = txt{optnii + 13};
% options.unbalanced  = {txt{optnii + 15:optnii + 16}};
% options.pattern     = txt{optnii + 18};
% options.demandmult  = txt{optnii + 21};
% options.emitterexp  = txt{optnii + 24};
% options.quality     = {txt{optnii + 26:optnii + 27}};
% options.diffusivity = txt{optnii + 29};
% options.tolerance   = txt{optnii + 31};

% get the time discretization
% times.duration        = txt{timeii+2};
% times.hydraulic       = txt{timeii+5};
% times.quality         = txt{timeii+8};
% times.patterntimestep = txt{timeii+11};
% times.paternstart     = txt{timeii+14};
% times.reporttimestep  = txt{timeii+17};
% times.reportstart     = txt{timeii+20};
% times.startclock      = {txt{timeii+23:timeii+24}};
% times.statistic       = txt{timeii+26};

  % FIRST get the coordinates of the nodes
  nnodes = vertii-coorii-3;
  id     = cell(1,nnodes);
  nid    = zeros(1,nnodes);
  xcoor  = zeros(1,nnodes);
  ycoor  = zeros(1,nnodes);
  inode=0;
  disp([' Number of Nodes : ',num2str(nnodes)]);
  for ii=coorii+2:vertii-2;
    inode=inode+1;
    nid(inode)=inode;
    iline=txt{ii};
    aa=find(isspace(iline));
    bb=find(diff(aa)>1);
    id{inode}=iline(1:aa(1)-1);
    xcoor(inode) = str2double(iline(aa(bb(1))+1 : aa(bb(1)+1)-1 ));
    ycoor(inode) = str2double(iline(aa(bb(2))+1 : aa(bb(2)+1)-1 ));
  end
  node.ntot = nnodes;
  node.nn = 0;
  node.no = 0;
  node.id = id;
  node.nid = nid;
  node.type = {};
  node.xcoor = xcoor;
  node.ycoor = ycoor;
  node.elevation = [];
  node.demand = [];
  node.pattern ={};

  % SECOND get the data from DEMAND nodes
  % elevation and demands.
  % then store the values in the same structure of nodes.

  nn        = reseii-juncii-3;
  node.nn   = nn;
  ntype     = cell(1,nnodes);
  pattern   = cell(1,nnodes);
  elevation = zeros(1,nnodes);
  demand    = zeros(1,nnodes);
  disp(['  - Number of Demand nodes : ',num2str(nn)]);
  for ii=juncii+2:reseii-2;
    iline=txt{ii}; % get the line
    aa=find(isspace(iline)); % extract the position of spaces
    bb=find(diff(aa)>1);  % find non consecutive spaces
    id2=iline(1:aa(1)-1); % extract the id2 of the junction which has data
    posnode=find(strcmp(id,id2)==1); % extract the position with respect with the id of all nodes
    if ~isempty(posnode);
      ntype{posnode}= 'D'; % mark the node as demand
      elevation(posnode) = str2double(iline(aa(bb(1))+1 : aa(bb(1)+1)-1 )); % extract elevation
      demand(posnode)    = str2double(iline(aa(bb(2))+1 : aa(bb(2)+1)-1 )); % extract demand
      if length(bb)<3; % check if it has pattern
        pattern{posnode}='-';
      else
        pattern{posnode}=iline(aa(bb(3))+1 : aa(bb(3)+1)-1 );
      end
    end
  end

  % THIRD get the data from RESERVOIRS if any
  nres=tankin-reseii-3;
  if nres>0; 
    node.no = nres;
    disp(['  - Number of Reservoirs : ',num2str(nres)]);
    for ii=reseii+2:tankin-2;
      iline=txt{ii}; % get the line
      aa=find(isspace(iline)); % extract the position of spaces
      bb=find(diff(aa)>1);  % find non consecutive spaces
      id3=iline(1:aa(1)-1); % extract the id2 of the junction which has data
      posnode=find(strcmp(id,id3)==1); % extract the position with respect with the id of all nodes
      ntype{posnode}= 'R'; % mark the node as demand
      elevation(posnode) = str2double(iline(aa(bb(1))+1 : aa(bb(1)+1)-1 )); % extract head
      if length(bb)<3; % check if it has pattern
        pattern{posnode}='-';
      else
        pattern{posnode}=iline(aa(bb(3))+1 : aa(bb(3)+1)-1 );
      end
    end
  else
    disp('  - Number of Reservoirs :  0'); 
  end

  % FOURTH get the data of the TANKS if any
  ntank=pipeii-tankin-3;
  initlevel = zeros(1,nnodes);
  minlevel  = zeros(1,nnodes);
  maxlevel  = zeros(1,nnodes);
  diameter  = zeros(1,nnodes);
  minvol    = zeros(1,nnodes);
  volcurve  = cell(1,nnodes);
  if ntank>0;
    node.no = node.no + ntank;
    disp(['  - Number of Tanks : ',num2str(ntank)]);
    for ii=tankin+2:pipeii-2; 
      iline=txt{ii}; % get the line
      aa=find(isspace(iline)); % extract the position of spaces
      bb=find(diff(aa)>1);  % find non consecutive spaces
      id4=iline(1:aa(1)-1); % extract the id2 of the junction which has data
      posnode=find(strcmp(id,id4)==1); % extract the position with respect with the id of all nodes
      ntype{posnode}= 'T'; % mark the node as demand
      elevation(posnode) = str2double(iline(aa(bb(1))+1 : aa(bb(1)+1)-1 )); % extract elevation
      initlevel(posnode) = str2double(iline(aa(bb(2))+1 : aa(bb(2)+1)-1 )); % extract initial level
      minlevel(posnode)=str2double(iline(aa(bb(3))+1 : aa(bb(3)+1)-1 )); % extract minimum level
      maxlevel(posnode)=str2double(iline(aa(bb(4))+1 : aa(bb(4)+1)-1 )); % extract maximum level
      diameter(posnode)=str2double(iline(aa(bb(5))+1 : aa(bb(5)+1)-1 )); % extract diameter
      minvol(posnode)=str2double(iline(aa(bb(6))+1 : aa(bb(6)+1)-1 )); % extract minimum volume
      if length(bb)<7;
        volcurve{posnode}='0';
      else
        volcurve{posnode}=iline(aa(bb(7))+1 : aa(bb(7)+1)-1 );
      end
    end
  else
    disp('  - Number of Tanks :  0');
  end
  node.type = ntype;
  node.elevation = elevation;
  node.demand = demand;
  node.pattern = pattern;
  node.initlevel = initlevel;
  node.minlevel = minlevel;
  node.maxlevel = maxlevel;
  node.diameter = diameter;
  node.minvol   = minvol;
  node.volcurve = volcurve;

  % FIFTH get the data of the PIPES (there must be at least two)
  % it will crush if some pipes don't have the proper ID of the nodes
  % which conform them (ni & nj). This is a problem in the INP file not from
  % the epanet_reader. 

  npipes=pumpii-pipeii-3; % number of pipes
  id5        = cell(1,npipes);
  node1      = cell(1,npipes);
  node2      = cell(1,npipes);
  pnode1_pos = zeros(1,npipes);
  pnode2_pos = zeros(1,npipes);
  plength    = zeros(1,npipes);
  pdiameter  = zeros(1,npipes);
  proughness = zeros(1,npipes);
  pminorloss = zeros(1,npipes);
  pstatus    = cell(1,npipes);
  if npipes>0;
    disp([' Number of Pipes : ',num2str(npipes)]);
    ipipe=0;
    for ii=pipeii+2:pumpii-2;
      ipipe=ipipe+1;
      iline=txt{ii}; % get the line
      aa=find(isspace(iline)); % extract the position of spaces
      bb=find(diff(aa)>1);  % find non consecutive spaces ">"
      
      id5{ipipe}        = iline(1:aa(1)-1); % extract the id5 of the PIPE which has data
      node1{ipipe}      = iline(aa(bb(1))+1 : aa(bb(1)+1)-1 ); % extract node 1
      node2{ipipe}      = iline(aa(bb(2))+1 : aa(bb(2)+1)-1 ); % extract node 1
      plength(ipipe)    = str2num(iline(aa(bb(3))+1 : aa(bb(3)+1)-1 )); % extract Length
      pdiameter(ipipe)  = str2num(iline(aa(bb(4))+1 : aa(bb(4)+1)-1 )); % extract diameter
      proughness(ipipe) = str2num(iline(aa(bb(5))+1 : aa(bb(5)+1)-1 )); % extract roughness
      pminorloss(ipipe) = str2num(iline(aa(bb(6))+1 : aa(bb(6)+1)-1 )); % extract minor loss coefficient
      pstatus{ipipe}    = iline(aa(bb(7))+1 : aa(bb(7)+1)-1 ); % extract status

      posnode1 = find(strcmp(id,node1{ipipe})==1); % extract the position of the FIRST node with respect to the ID of all nodes
      pnode1_pos(ipipe)=posnode1;
      if isempty(posnode1);
        disp([' ERROR AT pipe: ',num2str(ipipe),', node 1: ',node1{ipipe}]);
      end
      posnode2=find(strcmp(id,node2{ipipe})==1); % extract the position of the FIRST node with respect to the ID of all nodes
      pnode2_pos(ipipe)=posnode2;
      if isempty(posnode2);
        disp([' ERROR AT pipe: ',num2str(ipipe),', node 2: ',node2{ipipe}]);
      end
    end 
  else
    disp('No pipe data');
  end
  pipe.npipes = npipes;
  pipe.id = id5;
  pipe.ni = node1;
  pipe.nj = node2;
  pipe.nid=[pnode1_pos; pnode2_pos];
  pipe.length   = plength;
  pipe.diameter = pdiameter;
  pipe.minorloss = pminorloss;
  pipe.roughness = proughness;
  pipe.status = pstatus;

  % SIXTH get data from the PUMPS if any

  npumps     = valvii-pumpii-3; % get the number of pumps
  id6        = cell(1,npumps); % create the space for the id of the PUMPS
  bnode1     = cell(1,npumps); % create the space for the ni of each PUMP
  bnode2     = cell(1,npumps); % create the space for the nj of each PUMP
  btype      = cell(1,npumps); % container fo all the types of pump curves
  bcurveid   = cell(1,npumps); % ID of the corresponding curve fro the pump
  bnode1_pos = zeros(1,npumps);
  bnode2_pos = zeros(1,npumps);
  
  if npumps  > 0;
    disp([' Number of Pumps : ',num2str(npumps)]);
    ipump=0;
    for ii=pumpii+2:valvii-2;
      ipump=ipump+1;
      iline=txt{ii}; % get the line
      aa=find(isspace(iline)); % extract the position of spaces
      bb=find(diff(aa)>1);  % find non consecutive spaces
      id6{ipump}=iline(1:aa(1)-1); % extract the id5 of the PIPE which has data
      bnode1{ipump}      = iline(aa(bb(1))+1 : aa(bb(1)+1)-1 ); % extract node 1
      bnode2{ipump}      = iline(aa(bb(2))+1 : aa(bb(2)+1)-1 ); % extract node 1
      btype{ipump}       = iline(aa(bb(3))+1 : aa(bb(3)+1)-1 ); % extract type of pump curve
      bcurveid{ipump}    = iline(aa(bb(4))+1 : aa(bb(4)+1)-1 ); % extract curve ID
      
      posnode1=find(strcmp(id,bnode1{ipump})==1); % extract the position of the FIRST node with respect to the ID of all nodes
      bnode1_pos(ipump)=posnode1;
      if isempty(posnode1);
        disp([' ERROR AT pump: ',num2str(ipump),', node 1: ',bnode1{ipump}]);
      end
      posnode2=find(strcmp(id,bnode2{ipump})==1); % extract the position of the FIRST node with respect to the ID of all nodes
      bnode2_pos(ipump)=posnode2;
      if isempty(posnode2);
        disp([' ERROR AT pump: ',num2str(ipump),', node 2: ',bnode2{ipump}]);
      end
    end
  else
    disp(' Number of Pumps :  0');
  end
  pump.npumps = npumps;
  pump.id = id6;
  pump.ni = bnode1;
  pump.nj = bnode2;
  pump.nid = [bnode1_pos; bnode2_pos];
  pump.type = btype;
  pump.curveid  = bcurveid;

  % SEVENTH get data from the VALVES if any

  nvalves    = tagsii-valvii-3; % get the number of VALVES
  id7        = cell(1,nvalves);  % create the space for the id of the VALVES
  vnode1     = cell(1,nvalves);  % create the space for the ni of each VALVE
  vnode2     = cell(1,nvalves);  % create the space for the nj of each VALVE
  vposnode   = zeros(2,nvalves); % create the space for the ni-nj indexes of each VALVE 
  vdiameter  = zeros(1,nvalves); % create the space for the diameter of the VALVE
  vtype      = cell(1,nvalves);  % container fo all the types of VALVE
  vsetting   = cell(1,nvalves);  % SETTING of the VALVE
  vminorloss = zeros(1,nvalves); % ID of the corresponding curve fro the VALVE

  if nvalves > 0;
    disp([' Number of Valves : ',num2str(nvalves)]);
    ivalve=0;
    for ii=valvii+2:tagsii-2;
      ivalve=ivalve+1;
      iline=txt{ii}; % get the line
      aa=find(isspace(iline)); % extract the position of spaces
      bb=find(diff(aa)>1);  % find non consecutive spaces
      id7{ivalve}=iline(1:aa(1)-1); % extract the id6 of the VALVE which has data
      vnode1{ivalve}      = iline(aa(bb(1))+1 : aa(bb(1)+1)-1 ); % extract node 1 of VALVE
      vnode2{ivalve}      = iline(aa(bb(2))+1 : aa(bb(2)+1)-1 ); % extract node 2 of VALVE
      vdiameter(ivalve)   = str2num(iline(aa(bb(3))+1 : aa(bb(3)+1)-1 )); % extract diameter of VALVE
      vtype{ivalve}       = iline(aa(bb(4))+1 : aa(bb(4)+1)-1 ); % extract curve ID
      vsetting{ivalve}    = iline(aa(bb(5))+1 : aa(bb(5)+1)-1 ); % extract curve ID
      vminorloss(ivalve)  = str2num(iline(aa(bb(6))+1 : aa(bb(6)+1)-1 )); % extract minor loss coefficient of VALVE
      posnode1=find(strcmp(id,vnode1{ivalve})==1); % extract the position of the FIRST node with respect to the ID of all nodes
      vposnode(1,ivalve) = posnode1;
      if isempty(posnode1);
        disp([' ERROR AT valve: ',num2str(ivalve),', node 1: ',vnode1{ivalve}]);
      end
      posnode2=find(strcmp(id,vnode2{ivalve})==1); % extract the position of the SECOND node with respect to the ID of all nodes
      vposnode(2,ivalve) = posnode2;
      if isempty(posnode2);
        disp([' ERROR AT valve: ',num2str(ivalve),', node 2: ',vnode2{ivalve}]);
      end
    end
  else
    disp(' Number of Valves :  0');
  end
  valve.nv = nvalves;
  valve.id = id7;
  valve.ni = vnode1;
  valve.nj = vnode2;
  valve.nid = vposnode;
  valve.type = vtype;
  valve.diameter = vdiameter;
  valve.minorloss = vminorloss;
  valve.setting = vsetting;
  


  % Store substructures inside the output variable
  clear txt
  model2.nodes = node;
  model2.pipes = pipe;
  model2.pumps = pump;
  model2.valves = valve;


end % function