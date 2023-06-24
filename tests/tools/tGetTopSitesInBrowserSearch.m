classdef tGetTopSitesInBrowserSearch < matlab.unittest.TestCase
    % Unit tests for getTopSitesInGoogleSearch
    
    
    properties
        funcUnderTest = @getTopSitesInBrowserSearch
    end
    properties(TestParameter)
        CutoffNumber = {1,5,10}
    end

    methods(Test)

        function testCutoffNumber(test,CutoffNumber)
            engine = hSearchEngineMockup();
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, CutoffNumber, engine);
            
            test.verifyEqual(numel(websiteList),CutoffNumber, "Number of returned websites does not much cutoff number")
        end

        function testCutoffNumber_Negative(test)
            invalidCutoffNum = 11;
            engine = hSearchEngineMockup();
            dummySearchString = "dummy search";
            test.verifyError(@() test.funcUnderTest(dummySearchString, invalidCutoffNum, engine), ...
                "searchengine:cutoffNumExceedsReturnedItems");
        end
    end
end
