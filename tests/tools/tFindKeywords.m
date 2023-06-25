classdef tFindKeywords < matlab.unittest.TestCase
    % Unit tests for findKeywords
      
    properties
        funcUnderTest = @findKeywords
    end
    properties(TestParameter)
        method = {"bagOfWords"} 
        page = {"https://www.mathworks.com"}
    end

    methods(Test)

        function testOutput(test, page)
            
            [words, count] = test.funcUnderTest(page);
            test.verifyEqual(numel(words), numel(count));
            test.verifyTrue(isnumeric(count), "Count is not numeric")

        end
    end
end
