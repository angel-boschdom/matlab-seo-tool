classdef tSearchEngine < matlab.unittest.TestCase
    % Unit tests for googleapi.SearchEngine via the mock-up
    % hSearchEngineMockup
      
    properties
        objUnderTest = @hSearchEngineMockup
    end

    methods(Test)

        function testSearch(test)
            dataMatFile = "GoogleEngineSearchSample1.mat";
            engine = test.objUnderTest(dataMatFile);
            dummySearchString = "dummy search";

            data = engine.search(dummySearchString);

            test.verifyTrue(isEngineSearchOutputValid(data));

        end

        function testSearch_Negative(test)
            dataMatFile = "GoogleEngineInvalidSearchData.mat";
            engine = test.objUnderTest(dataMatFile);
            dummySearchString = "dummy search";

            data = engine.search(dummySearchString);

            test.verifyFalse(isEngineSearchOutputValid(data));
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
    itemsIsAStruct = isstruct(items);
    if ~itemsIsAStruct
        isValid = false;
        return
    end
    allItemsAreValid = true;
    for idxItem = numel(items):-1:1
        thisItem = items(idxItem);
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