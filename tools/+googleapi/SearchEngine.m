classdef SearchEngine < InternetSearchEngine
    %SEARCHENGINE Interface a Custom Search Engine from Google API

    properties
        ID      (1,1) string = "<your-cse-id>" % Google programmable search engine ID. You can find it in https://programmablesearchengine.google.com/controlpanel/
        APIKey  (1,1) string = "<your-cse-api-key>" % Programmable search engine API key. You can find it in https://programmablesearchengine.google.com/controlpanel/
    end
    
    methods
        
        function data = search(obj,searchString)
            %SEARCH Perform a search
            arguments (Input)
                obj googleapi.SearchEngine
                searchString (1,1) string
            end
            arguments (Output)
                data    (1,1) struct
            end

            apiKey = obj.APIKey;
            searchEngineID = obj.ID;

            url = sprintf('https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s', apiKey, searchEngineID, urlencode(searchString));
            data = webread(url);
        end
    end
end