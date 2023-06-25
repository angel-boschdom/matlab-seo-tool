function topSites = getTopSitesInBrowserSearch(searchString, engine, options)
%GETTOPSITESINGOOGLESEARCH Get the top sites in a google search
%   Returns list of site adresses from a google programmable search engine
%   API call.
    
    arguments
        searchString      (1,1) string % String to search in the programmable search engine
        engine            (1,1) InternetSearchEngine
        options.maxSites  (1,1) double = inf % Maximum number of returned sites
    end

    validateMaxSites(options.maxSites);

    data = engine.search(searchString);
    items = data.items;
    numItems = numel(items);
    cutoffNum = int32(floor(options.maxSites));
    numTopSites = min(numItems,cutoffNum);
    for idxSite = numTopSites:-1:1
        topSites(idxSite,1) = string(items{idxSite}.link);
    end

    end

    function validateMaxSites(maxSites)
        if maxSites < 1
            errID = "searchengine:maxSitesMustExceedOne";
            msg = strcat("maxSites must be greater than 1");
            ME = MException(errID,msg);
            throw(ME);
        end
    end