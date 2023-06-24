function topSites = getTopSitesInBrowserSearch(searchString, cutoffNum, engine)
%GETTOPSITESINGOOGLESEARCH Get the top sites in a google search
%   Returns list of site adresses from a google programmable search engine
%   API call.
    
    arguments
        searchString   (1,1) string % String to search in the programmable search engine
        cutoffNum      (1,1) uint32 % Maximum number of returned sites
        engine
    end

    data = engine.search(searchString);
    items = data.items;
    numItems = numel(items);
    if cutoffNum > numItems
        errID = "searchengine:cutoffNumExceedsReturnedItems";
        msg = strcat("cutoffNum exceeds the number of items returned. Use a cutoffNum smaller than ", ...
            num2str(numItems));
        ME = MException(errID,msg);
        throw(ME);
    end
    numTopSites = min(numItems,cutoffNum);
    for idxSite = numTopSites:-1:1
        topSites(idxSite,1) = string(items{idxSite}.link);
    end

end