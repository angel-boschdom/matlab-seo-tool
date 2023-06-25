classdef tGetTopSitesInBrowserSearch < matlab.unittest.TestCase
    % Unit tests for getTopSitesInBrowserSearch
      
    properties
        funcUnderTest = @getTopSitesInBrowserSearch
    end
    properties(TestParameter)
        maxSites = {1,5,10}
        dataMatFile = {"GoogleEngineSearchSample1_CellItems.mat", ...
                       "GoogleEngineSearchSample2_CellItems.mat", ...
                       "GoogleEngineSearchSample3_StructItems.mat"}
    end

    methods(Test)

        function testOutput(test, dataMatFile)
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine);
            numSites = numel(websiteList);
            for idxSite = 1:numSites
                test.verifySubstring(websiteList(idxSite), "http", ...
                    "The output does not contain http and hence is not a valid website URL")
            end
        end

        % function testOutput_Negative(test)
        %     dataMatFile = "GoogleEngineInvalidSearchData.mat";
        %     engine = hSearchEngineMockup(dataMatFile);
        %     dummySearchString = "dummy search";
        %     test.verifyError(@() test.funcUnderTest(dummySearchString, engine), ...
        %         "getTopSitesInBrowserSearch:invalidSearchEngineOutput");
        % end

        function testMaxSitesOption(test, maxSites, dataMatFile)
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine, 'maxSites', maxSites);
            
            test.verifyEqual(numel(websiteList),maxSites, "Number of returned websites does not much cutoff number")
        end

        function testMaxSitesOptionAlternativeSyntax(test, maxSites, dataMatFile)
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            websiteList = test.funcUnderTest(dummySearchString, engine, maxSites=maxSites);
            
            test.verifyEqual(numel(websiteList),maxSites, "Number of returned websites does not much cutoff number")
        end

        function testMaxSitesOption_Negative(test, dataMatFile)
            invalidMaxSites = 0.5;
            engine = hSearchEngineMockup(dataMatFile);
            dummySearchString = "dummy search";
            test.verifyError(@() test.funcUnderTest(dummySearchString, engine, 'maxSites', invalidMaxSites), ...
                "getTopSitesInBrowserSearch:maxSitesMustExceedOne");
        end
    end
end
