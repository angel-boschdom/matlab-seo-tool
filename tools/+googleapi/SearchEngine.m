classdef SearchEngine < InternetSearchEngine
    %SEARCHENGINE Interface a Custom Search Engine from Google API

    properties
        ID      (1,1) string = "<your-cse-id>" % Google programmable search engine ID. You can find it in https://programmablesearchengine.google.com/controlpanel/
        APIKey  (1,1) string = "<your-cse-api-key>" % Programmable search engine API key. You can find it in https://programmablesearchengine.google.com/controlpanel/
    end
    
    methods

        function obj = SearchEngine()
            id = getenv("GOOGLE_SEARCH_ENGINE_ID");
            if isempty(id)
                errID = "googleapi:SearchEngine:idNotFound";
                msg = strcat("GOOGLE_SEARCH_ENGINE_ID environent variable not found. Use setenv() to specify you programmable search engine ID.");
                ME = MException(errID,msg);
                throw(ME);
            end
            apiKey = getenv("GOOGLE_SEARCH_ENGINE_API_KEY");
            if isempty(apiKey)
                errID = "googleapi:SearchEngine:apiKeyNotFound";
                msg = strcat("GOOGLE_SEARCH_ENGINE_API_KEY environent variable not found. Use setenv() to specify you API key.");
                ME = MException(errID,msg);
                throw(ME);
            end

            obj.ID = id;
            obj.APIKey = apiKey;
        end
        
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
            if isstruct(data.items) 
                % convert items to cell array
                items = data.items;
                for idxItem = numel(items):-1:1
                    cellItems{idxItem,1} = data.items(idxItem);
                end
                data.items = cellItems;
            end
        end
    end
end