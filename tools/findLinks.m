function links = findLinks(url)
    arguments(Input)
        url (1,1) string % URL to search page for links
    end
    arguments(Output)
        links (:,1) string % list of urls that are linked in the url.
    end

    % Use the webread function to read the content of the URL
    content = webread(url);

    if isTextAnalyticsToolboxInstalled() % recommended, more robust method
        % Parse the HTML code using htmlTree
        tree = htmlTree(content);    
        % Find all <a> tags
        aTags = findElement(tree, "a");  
        % Extract the href attribute of each link
        hrefs = getAttribute(aTags, 'href');
        % Remove missing
        hrefs(ismissing(hrefs))=[];
        % Remove anchor tags / internal links
        hrefs(startsWith(hrefs,"#")) = [];
        % double-slashes indicate a protocol-relative URL. Assume https
        hrefs(startsWith(hrefs,"//")) = strcat("https:", hrefs(startsWith(hrefs,"//")));
        % single-slash indicates relative path to the root site. Add root URL
        hrefs(startsWith(hrefs,"/")) = addRootSite(hrefs(startsWith(hrefs,"/")), url);
        % no slash indicates relative path
        hrefs(~startsWith(hrefs, "http")) = strcat(url,hrefs(~startsWith(hrefs, "http")));
        % don't keep the queries
        links = removeQueries(hrefs);
    else
        % Use regular expressions to find all the links in the content
        linkPattern = '<a\s+href=["''](http[s]?://[^"''\s>]+)["'']'; % Pattern to match http or https links
        matches = regexp(content, linkPattern, 'tokens');       
        % Extract the links from the matches
        links = cellfun(@(x) x{1}, matches, 'UniformOutput', false);
        links = string(links);
    end

end

function isInstalled = isTextAnalyticsToolboxInstalled()
    % Get information about installed toolboxes
    toolboxInfo = ver;
    
    % Check if Text Analytics Toolbox is installed
    isInstalled = any(strcmp({toolboxInfo.Name}, 'Text Analytics Toolbox'));
end

function newHref = addRootSite(href, url)
    if ~endsWith(url, '/')
        url = strcat(url,'/');
    end
    newHref = strcat("https://", extractBetween(url, "//", "/"), href);
end

function hrefs = removeQueries(hrefs)
    for idx = 1:numel(hrefs)
        if contains(hrefs(idx), '?')
           hrefs(idx) = extractBefore(hrefs(idx),'?');
        end
    end
end