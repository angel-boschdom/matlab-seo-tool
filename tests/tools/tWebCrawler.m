classdef tWebCrawler < matlab.unittest.TestCase
    % Unit tests for WebCrawler
      
    properties
        objUnderTest = @WebCrawler
    end
    properties(TestParameter)
        page = {"https://www.mathworks.com/help/matlab/", ...
                "https://en.wikipedia.org/wiki/Stoicism"}
        maxLinks = {10,20}
        filter = {@(s)startsWith(s, "https://www.mathworks.com/"), ...
                  @(s)contains(s, "wikipedia")}
    end

    methods(Test)

        function testExplore(test, page, maxLinks, filter)
            crawler = test.objUnderTest();
            crawler.maxLinks = maxLinks;
            crawler.filter = filter;
            crawler.explore(page);
            h = crawler.plotGraph();
            links = crawler.VisitedURLs;
            numSites = numel(links);
            for idxSite = 1:numSites
                test.verifySubstring(links(idxSite), "http", ...
                    "The output does not contain http and hence is not a valid website URL")
            end
            fig = h.Parent.Parent;
            close(fig);
        end
        
    end
end
