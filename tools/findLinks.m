function links = findLinks(url)
    arguments(Input)
        url (1,1) string % URL to search page for links
    end
    arguments(Output)
        links (:,1) string % list of urls that are linked in the url.
    end

    % Use the webread function to read the content of the URL
    content = webread(url);
    
    % Use regular expressions to find all the links in the content
    linkPattern = '<a\s+href=["''](http[s]?://[^"''\s>]+)["'']'; % Pattern to match http or https links
    matches = regexp(content, linkPattern, 'tokens');
    
    % Extract the links from the matches
    links = cellfun(@(x) x{1}, matches, 'UniformOutput', false);
    links = string(links);

end