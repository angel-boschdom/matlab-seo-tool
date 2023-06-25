classdef hSearchEngineMockup < InternetSearchEngine
    %HSEARCHENGINEMOCKUP Helper class to mock a SearchEngine class. This
    %enable testing without use of API Keys.

    properties
        ID      (1,1) string 
        APIKey  (1,1) string 
    end

    properties(Access=private)
        DummyData
    end
    
    methods
        function obj = hSearchEngineMockup(dataMatFile)
            %SEARCHENGINE Construct an instance of this class
            obj.ID = "dummyID";
            obj.APIKey = "dummyAPIKey";

            loadOut = load(dataMatFile);
            obj.DummyData = loadOut.data;
        end
        
        function data = search(obj,searchString)
            %SEARCH Perform a search
            arguments
                obj
                searchString (1,1) string
            end
            
            data = obj.DummyData;

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

