classdef tSearchEngine < matlab.unittest.TestCase
    % Unit tests for googleapi.SearchEngine via the mock-up
    % hSearchEngineMockup
      
    properties
        objUnderTest = @hSearchEngineMockup
    end
    properties(TestParameter)
        dataMatFile = {"GoogleEngineSearchSample1_CellItems.mat", ...
                       "GoogleEngineSearchSample2_CellItems.mat", ...
                       "GoogleEngineSearchSample3_StructItems.mat"}
    end

    methods(Test)

        function testSearch(test, dataMatFile)
            engine = test.objUnderTest(dataMatFile);
            dummySearchString = "dummy search";

            data = engine.search(dummySearchString);

            test.verifyTrue(isEngineSearchOutputValid(data));

        end
        
    end
end

function isValid = isEngineSearchOutputValid(data)
    
    isValid = true;

    if ~isstruct(data)
        isValid = false;
        return
    end

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