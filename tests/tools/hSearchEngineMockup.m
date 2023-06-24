classdef hSearchEngineMockup
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
        function obj = hSearchEngineMockup()
            %SEARCHENGINE Construct an instance of this class
            obj.ID = "dummyID";
            obj.APIKey = "dummyAPIKey";

            loadOut = load("GoogleEngineSearchSample.mat");
            obj.DummyData = loadOut.data;
        end
        
        function data = search(obj,searchString)
            %SEARCH Perform a search
            arguments
                obj
                searchString (1,1) string
            end
            
            data = obj.DummyData;
        end
    end
end

