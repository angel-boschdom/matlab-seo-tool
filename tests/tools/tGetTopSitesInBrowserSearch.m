classdef tGetTopSitesInBrowserSearch < matlab.unittest.TestCase
    % Unit tests for getTopSitesInGoogleSearch
    
    
    properties
        funcUnderTest = @getTopSitesInBrowserSearch
    end
    properties(TestParameter)
        maxSites = {1,5,10}
    end

    methods(Test)

        function testOutput(test)
            engine = hSearchEngineMockup();
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine);
            numSites = numel(websiteList);
            for idxSite = 1:numSites
                test.verifySubstring(websiteList(idxSite), "http", ...
                    "The output does not contain http and hence is not a valid website URL")
            end
        end

        function testMaxSitesOption(test,maxSites)
            engine = hSearchEngineMockup();
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine, 'maxSites', maxSites);
            
            test.verifyEqual(numel(websiteList),maxSites, "Number of returned websites does not much cutoff number")
        end

        function testMaxSitesOptionAlternativeSyntax(test,maxSites)
            engine = hSearchEngineMockup();
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine, maxSites=maxSites);
            
            test.verifyEqual(numel(websiteList),maxSites, "Number of returned websites does not much cutoff number")
        end

        function testMaxSitesOption_Negative(test)
            invalidMaxSites = 0.5;
            engine = hSearchEngineMockup();
            dummySearchString = "dummy search";
            test.verifyError(@() test.funcUnderTest(dummySearchString, engine, 'maxSites', invalidMaxSites), ...
                "searchengine:maxSitesMustExceedOne");
        end
    end
end
