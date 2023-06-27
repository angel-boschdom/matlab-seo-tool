classdef WebCrawler < handle
    %WEBCRAWLER Agent to visit web links recursively and store information
    %in a graph.
    
    properties
        maxLinks (1,1) int32 = int32(100) % maximum numbers of explored links
    end
    properties(SetAccess=private)
        VisitedURLs (:,1) string = "" % list of visited URLs
        Graph (1,1) digraph = digraph() % graph of visited URLs. An edge A->B means A has a link pointing to B.
        LinkCount (1,1) int32 = int32(1) % Number of visited links
        Diagnostics (:,1) string = strings(0) % diagnostic messages about errors
    end
    
    methods
        function explore(obj, url)
            node = getNodeFromURL(url,obj);
            parentID = obj.LinkCount;
            
            if strcmp(obj.VisitedURLs,"")
                obj.VisitedURLs = url;
                obj.Graph = obj.Graph.addnode(node);
            end
            
            try
                links = findLinks(url);  
            catch exc
                obj.Diagnostics(end+1) = strcat("Error finding links for ", url, " : ", exc.identifier);
                obj.LinkCount = obj.LinkCount + 1;
                links = [];
            end
            
            for idxLink = 1:numel(links)   
                thisLink = links(idxLink); 
                obj.LinkCount = obj.LinkCount + 1;
                obj.VisitedURLs = unique([obj.VisitedURLs(:) ; thisLink]);
                
                if isNewLink(thisLink, obj.VisitedURLs)                               
                    childNode = getNodeFromURL(thisLink,obj);
                    obj.Graph = obj.Graph.addnode(childNode);
                    obj.Graph = obj.Graph.addedge(...
                        num2str(parentID),...
                        num2str(obj.LinkCount));
                else
                    obj.Graph = obj.Graph.addedge(...
                        num2str(parentID),...
                        num2str(parentID));
                end
                if obj.LinkCount < obj.maxLinks
                    obj.explore(thisLink);
                else
                    return % Exit condition: stop recursion if LinkCount exceeds maxLinks
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
            msize = 2.5*(outdegree(G) + 3)./max(outdegree(G));                % marker size
            ncol = outdegree(G) + 3;                                        % node colors
            named = outdegree(G) > 7;                                       % nodes to label
            h = plot(G, 'MarkerSize', msize, 'NodeCData', ncol);            % plot graph
            layout(h,'force3','Iterations',30)                              % change layout
            labelnode(h, find(named), G.Nodes.Name(named));                 % add node labels
            title('Links Visited')                                          % add title
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

function bool = isNewLink(link,visitedlinks)
    bool = any(strcmp(link,visitedlinks));
end