function topSites = getTopSitesInGoogleSearch(searchString, cutoffNum, searchEngineID, apiKey)
%GETTOPSITESINGOOGLESEARCH Get the top sites in a google search
%   Returns list of site adresses from a google programmable search engine
%   API call.
    
    arguments
        searchString   (1,1) string % String to search in the programmable search engine
        cutoffNum      (1,1) uint32 % Maximum number of returned sites
        searchEngineID (1,1) string % Google programmable search engine ID. You can find it in https://programmablesearchengine.google.com/controlpanel/
        apiKey         (1,1) string % Programmable search engine API key. You can find it in https://programmablesearchengine.google.com/controlpanel/
    end

    url = sprintf('https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s', apiKey, searchEngineID, urlencode(searchString));
    
    try
        data = webread(url);
        items = data.items;
        numTopSites = min(numel(items),cutoffNum);
        for idxSite = numTopSites:-1:1
            topSites(idxSite,1) = string(items{idxSite}.link);
        end
    catch
        topSites = "";
    end
end