function myNet = readRoadNetwork()
%% This function read raw data into a structure. 
% input: None
% output: myNet, a sctruct contains the road network
%
% Yiliang Xiong <wlxiong@gmail.com>
% Sat Dec 11 21:44:42 2010 +0800

%% the raw data for the network
% % data set ONE
% Nodenum=5; 
% Linknum=8; 
% 
% beginnode=[1,1,1,2,3,4,3,2];
%   endnode=[2,3,4,4,4,5,5,5];
% %ta=zeros(1,Linknum)
% ta=[2,1,-10,2,3,4,5,4];

% data set TWO
Nodenum=9;
Linknum=16;

beginnode=[1,2,1,1,2,2,3,4,5,4,4,5,5,6,7,8];
  endnode=[2,3,4,5,5,6,6,5,6,7,8,8,9,9,8,9];
%ta=zeros(1,Linknum)
ta=[5,7,6,-1,9,-2,-3,5,2,8,-5,-7,10,8,-2,-1];

%% create refined data
% the adjacent lists: for each node it recods the nodes that are adjacent to it
adjNode = -ones(Nodenum, Nodenum); 
% the number of adjacent nodes for each node
numAdjNode = zeros(Nodenum, 1);
% the travel time on each link 
linkTime = zeros(Nodenum, Nodenum);
% construct the adjacent lists for the network
for i = 1:Linknum
	node = beginnode(i);
	numAdjNode(node) = numAdjNode(node) + 1;
	adjNode(node, numAdjNode(node)) = endnode(i);
	linkTime(node, numAdjNode(node)) = ta(i);
end	

% create a structure for the road network
myNet = struct( 'numNode', Nodenum, ...
				'numLink', Linknum,...
				'adjNode', adjNode, ...
				'numAdjNode', numAdjNode, ...
				'linkTime', linkTime);

% end of main function
end
