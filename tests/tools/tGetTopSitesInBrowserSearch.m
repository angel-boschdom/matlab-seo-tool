classdef tGetTopSitesInBrowserSearch < matlab.unittest.TestCase
    % Unit tests for getTopSitesInBrowserSearch
      
    properties
        funcUnderTest = @getTopSitesInBrowserSearch
    end
    properties(TestParameter)
        maxSites = {1,5,10}
    end

    methods(Test)

        function testOutput(test)
            dataMatFile = "GoogleEngineSearchSample1.mat";
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine);
            numSites = numel(websiteList);
            for idxSite = 1:numSites
                test.verifySubstring(websiteList(idxSite), "http", ...
                    "The output does not contain http and hence is not a valid website URL")
            end
        end

        function testOutput_Negative(test)
            dataMatFile = "GoogleEngineInvalidSearchData.mat";
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            test.verifyError(@() test.funcUnderTest(dummySearchString, engine), ...
                "getTopSitesInBrowserSearch:invalidSearchEngineOutput");
        end

        function testMaxSitesOption(test,maxSites)
            dataMatFile = "GoogleEngineSearchSample1.mat";
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine, 'maxSites', maxSites);
            
            test.verifyEqual(numel(websiteList),maxSites, "Number of returned websites does not much cutoff number")
        end

        function testMaxSitesOptionAlternativeSyntax(test,maxSites)
            dataMatFile = "GoogleEngineSearchSample1.mat";
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine, maxSites=maxSites);
            
            test.verifyEqual(numel(websiteList),maxSites, "Number of returned websites does not much cutoff number")
        end

        function testMaxSitesOption_Negative(test)
            invalidMaxSites = 0.5;
            dataMatFile = "GoogleEngineSearchSample1.mat";
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            test.verifyError(@() test.funcUnderTest(dummySearchString, engine, 'maxSites', invalidMaxSites), ...
                "getTopSitesInBrowserSearch:maxSitesMustExceedOne");
        end
    end
end
