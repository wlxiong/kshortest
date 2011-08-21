function [myTime, myPath, pathLeng] = bellmanFord(myNet, s, t, k)
%% This function searchs the first k-shortest paths using 
%  multi-label version of Bellman-Ford algorithm. 
% input: myNet, a sctruct contains the road network
%		s, the starting node of the paths
% 		t, the terminating node of the paths
%		k, the number of shortest paths
% output: myTime, the travel time of all the paths
%       myPath, a struct contains the k-shortest path
%       pathLeng, the length of paths
%
% Yiliang Xiong <wlxiong@gmail.com>
% Sat Dec 11 21:44:42 2010 +0800

%% define variables
% the quickest travel times
quickTime = Inf(myNet.numNode, k);
% the list of preceding nodes
preNode = -ones(myNet.numNode, k);
% the list of preceding labels
preLabel = -ones(myNet.numNode, k);

%% a queue for searching: first field -- node, second field -- label
sizeQueue = myNet.numLink;
queue = -ones(sizeQueue, 2);
% top of the queue
top = 0;
% bottom of the queue
bottom = 0;
% length of the queue
leng = 0;
% push method
	function push(node, label)
		leng = leng + 1;
		bottom = mod(bottom, sizeQueue + 1) + 1;
		queue(bottom, 1) = node;
		queue(bottom, 2) = label;
	end
% pop method
	function [node, label] = pop()
		if leng < 1
			error('queue:pop', 'Cannot pop an empty quque. ')
		else
			leng = leng - 1;
		end
		top = mod(top, sizeQueue + 1) + 1;
		node = queue(top, 1);
		label = queue(top, 2);
	end

%% Bellman-Ford algorithm
% initialize the travel time for starting node
quickTime(s, 1) = 0;
% push the starting node into the queue
push(s, 1);
while leng > 0
	[node, label] = pop();
	for i = 1:myNet.numAdjNode(node)
		nextNode = myNet.adjNode(node, i);
		travelTime = myNet.linkTime(node, i);
		% linear time search (to be replaced in future)
		[maxTime, itsLabel] = max(quickTime(nextNode, :));
		if quickTime(node, label) + travelTime < maxTime
			quickTime(nextNode, itsLabel) = quickTime(node, label) + travelTime;
			preNode(nextNode, itsLabel) = node;
			preLabel(nextNode, itsLabel) = label;
			push(nextNode, itsLabel);
		end
	end
end

%% construct all the shortest paths
% sort the paths
quickTimeTab = [quickTime(t, :); ...
				preNode(t, :); ...
				preLabel(t, :)];
[sortedTab, sortedIndex] = sortrows(transpose(quickTimeTab), 1);
% cut out the paths with infinite travel time (actually it does NOT exist)
finiteTab = sortedTab(sortedTab(:,1)<Inf, :);
% sometimes the number of paths between (s,t) is smaller than k
kk = size(finiteTab, 1);
% throw a warning if kk < k
if kk < k
    warning('bellmanFord:constructPaths', ...
    'The number of paths between (%d,%d) is %d, smaller than %d! ', ...
    s, t, kk, k);
end
% the quickest travel times
myTime = finiteTab(:, 1);
% list of all the shortest paths
myPath = -ones(kk, myNet.numNode);
pathLeng = zeros(kk, 1); 
for i = 1:kk
	iNode = t;
	iLabel = sortedIndex(i);
	while iNode > 0 && iLabel > 0
		pathLeng(i) = pathLeng(i) + 1;
		myPath(i, pathLeng(i)) = iNode;
		nextNode = preNode(iNode, iLabel);
		nextLabel = preLabel(iNode, iLabel);
        iNode = nextNode;
        iLabel = nextLabel;
	end
end

% end of main function
end
