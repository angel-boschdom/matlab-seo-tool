classdef tFindLinks < matlab.unittest.TestCase
    % Unit tests for findLinks
      
    properties
        funcUnderTest = @findLinks
    end
    properties(TestParameter)
        page = {"https://www.mathworks.com/help/matlab/"}
    end

    methods(Test)

        function testOutput(test, page)
            
            links = test.funcUnderTest(page);
            numSites = numel(links);
            for idxSite = 1:numSites
                test.verifySubstring(links(idxSite), "http", ...
                    "The output does not contain http and hence is not a valid website URL")
            end
        end

        function testOutput_Negative(test)
            
            invalidPage = "<dummypage>";
            test.verifyError(@() test.funcUnderTest(invalidPage), ...
                'MATLAB:webservices:ExpectedProtocol')
            
        end

    end
end
