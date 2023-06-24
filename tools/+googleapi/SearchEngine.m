classdef SearchEngine
    %SEARCHENGINE Interface a Custom Search Engine from Google API

    properties
        ID      (1,1) string % Google programmable search engine ID. You can find it in https://programmablesearchengine.google.com/controlpanel/
        APIKey  (1,1) string % Programmable search engine API key. You can find it in https://programmablesearchengine.google.com/controlpanel/
    end
    
    methods
        function obj = SearchEngine(id,apiKey)
            %SEARCHENGINE Construct an instance of this class
            obj.ID = id;
            obj.APIKey = apiKey;
        end
        
        function data = search(obj,searchString)
            %SEARCH Perform a search
            arguments
                obj googleapi.SearchEngine
                searchString (1,1) string
            end

            apiKey = obj.APIKey;
            searchEngineID = obj.ID;

            url = sprintf('https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s', apiKey, searchEngineID, urlencode(searchString));
            data = webread(url);
        end
    end
end

