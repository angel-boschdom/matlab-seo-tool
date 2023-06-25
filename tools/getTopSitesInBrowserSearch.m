function topSites = getTopSitesInBrowserSearch(searchString, engine, options)
%GETTOPSITESINBROWSERSEARCH Get the top sites in an internet search
%   Returns list of site adresses from a browser internet search
    
    arguments
        searchString      (1,1) string % String to search
        engine            (1,1) InternetSearchEngine
        options.maxSites  (1,1) double = inf % Maximum number of returned sites
    end

    validateMaxSites(options.maxSites);
    data = engine.search(searchString);    
    validateSearchEngineOutputData(data);
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
        errID = "getTopSitesInBrowserSearch:maxSitesMustExceedOne";
        msg = strcat("maxSites must be greater than 1");
        ME = MException(errID,msg);
        throw(ME);
    end
end

function validateSearchEngineOutputData(data)
    isValid = isEngineSearchOutputValid(data);
    if ~isValid
        errID = "getTopSitesInBrowserSearch:invalidSearchEngineOutput";
        msg = strcat("Browser search results return invalid data. Check engine configuration.");
        ME = MException(errID,msg);
        throw(ME);
    end
end

function isValid = isEngineSearchOutputValid(data)
    arguments
        data (1,1) struct
    end
    
    isValid = true;

    hasItemsField = isfield(data, "items");
    if ~hasItemsField
        isValid = false;
        return
    end
    items = data.items;
    itemsIsACell = iscell(items);
    if ~itemsIsACell
        isValid = false;
        return
    end
    allItemsAreValid = true;
    for idxItem = numel(items):-1:1
        thisItem = items{idxItem};
        hasLinkField = isfield(thisItem, "link");
        if ~hasLinkField
            allItemsAreValid = false;
        else
            link = thisItem.link;
            if (~ischar(link)) && (~isstring(link)) % link is not text (char or string)
                allItemsAreValid = false;
            end
        end
    end
    if ~allItemsAreValid
        isValid = false;
        return
    end
end