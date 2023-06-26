classdef tSimpleSearchEngine < matlab.unittest.TestCase
    % Unit tests for SimpleSearchEngine
      
    properties
        objUnderTest = @SimpleSearchEngine
    end
    properties(TestParameter)
        searchString = {"mathworks", ...
                        "matlab online", ...
                        "who was Marcus Aurelius"}
    end

    methods(Test)

        function testSearch(test, searchString)
            engine = test.objUnderTest();
            data = engine.search(searchString);
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