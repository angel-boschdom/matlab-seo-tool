classdef WebCrawler < handle
    %WEBCRAWLER Agent to visit web links recursively and store information
    %in a graph.
    
    properties
        maxLinks (1,1) int32 = int32(100) % maximum numbers of explored links
        filter (1,1) function_handle = @(str) true; % filter links to explore
    end
    properties(SetAccess=private)
        RootURL (1,1) string
        VisitedURLs (:,1) string = "" % list of visited URLs
        Graph (1,1) digraph = digraph() % graph of visited URLs. An edge A->B means A has a link pointing to B.
        LinkCount = 1 % Number of visited links
        Diagnostics (:,1) string = strings(0) % diagnostic messages about errors
    end
    
    methods
        function explore(obj, url)
            if strcmp(obj.VisitedURLs,"")
                obj.RootURL = url;
                obj.VisitedURLs = url;
                node = getNodeFromURL(url,obj);
                obj.Graph = obj.Graph.addnode(node);
            end    
            if isNewURL(url,obj.VisitedURLs)
                node = getNodeFromURL(url,obj);
                obj.Graph = obj.Graph.addnode(node);
                parentID = node.Name;
            else
                parentID = string(obj.Graph.Nodes.Name(findSameURL(obj.Graph.Nodes.URL, url)));
            end    
            try
                links = findLinks(url);  
                links = links(arrayfun(obj.filter, links));
                links = setdiff(links, obj.VisitedURLs); % remove already visited links
            catch exc
                obj.Diagnostics(end+1) = strcat("Error finding links for ", url, " : ", exc.identifier);
                obj.LinkCount = obj.LinkCount + 1;
                links = [];
            end           
            for idxLink = 1:numel(links)   
                thisLink = links(idxLink); 
                obj.LinkCount = obj.LinkCount + 1;
                if isNewURL(thisLink, obj.VisitedURLs)
                    childNode = getNodeFromURL(thisLink,obj);
                    obj.Graph = obj.Graph.addnode(childNode);                         
                    obj.VisitedURLs = [obj.VisitedURLs(:) ; thisLink];
                    childID = childNode.Name;
                else
                    childID = string(obj.Graph.Nodes.Name(findSameURL(obj.Graph.Nodes.URL, thisLink)));
                end
                obj.Graph = obj.Graph.addedge(parentID,childID);  
                if ~strcmp(parentID,childID) % not pointing to itself
                    if obj.LinkCount < obj.maxLinks 
                        obj.explore(thisLink);
                    else
                        break % exit for loop
                    end
                end
            end
        end
    
        function h = plotGraph(obj)
            % Code based on blog from Loren on the art of MATLAB (thank you!)
            %   https://blogs.mathworks.com/loren/2017/07/10/web-scraping-and-mining-unstructured-data-with-matlab/
            G = obj.Graph;                                           
            bins = conncomp(G,'type', 'weak', 'OutputForm', 'cell');        % get connected comps
            [~, idx] = max(cellfun(@length, bins));                         % find largest comp
            G = subgraph(G, bins{idx});                                     % subgraph largest comp
            figure                                                          % new figure
            colormap cool                                                   % use cool colormap
            msize = 10*(outdegree(G) + 3)./max(max(outdegree(G),1));       % marker size
            ncol = outdegree(G) + 3;                                        % node colors
            named = outdegree(G) > 7;                                       % nodes to label
            h = plot(G, 'MarkerSize', msize, 'NodeCData', ncol);            % plot graph
            layout(h,'force3','Iterations',30)                              % change layout
            labelnode(h, find(named), G.Nodes.Name(named));                 % add node labels
            urlSplit = strsplit(obj.RootURL, '?');                          % remove queries
            title(strcat("Links visited from <", urlSplit(1), ">"))         % add title
            axis tight off                                                  % set axis
            set(gca,'clipping','off')                                       % turn off clipping                
        end
    end
end

function node = getNodeFromURL(URL,crawler)
    Name = string(num2str(crawler.LinkCount)); 
    try
        Keywords = {findKeywords(URL,"maxKeywords",10)};
    catch exc
        crawler.Diagnostics(end+1) = strcat("Error during keyword extraction for ", URL, " : ", exc.identifier);
        Keywords = {"<error during keyword extraction>"}; 
    end
    node = table(Name,URL,Keywords);
end

function bool = isNewURL(link,visitedlinks)
    bool = true;
    for idx = 1:numel(visitedlinks)
        if areSameURL(link, visitedlinks(idx))
            bool = false;
            return
        end
    end
end

function idxSameURL = findSameURL(listOfURLs, url)
    for idx = 1:numel(listOfURLs)
        if areSameURL(listOfURLs(idx),url)
            idxSameURL = idx;
            return
        end
    end
    idxSameURL = [];
end

function bool = areSameURL(url1,url2)
    url1 = stripLastTrailingSlashes(url1);
    url2 = stripLastTrailingSlashes(url2);
    bool = strcmp(url1,url2);
end

function cleanStr = stripLastTrailingSlashes(str)
    str = char(str);
    while endsWith(str, '/')
        str(end) = [];
    end
    cleanStr = str;
end