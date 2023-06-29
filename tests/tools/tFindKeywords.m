classdef tFindKeywords < matlab.unittest.TestCase
    % Unit tests for findKeywords
      
    properties
        funcUnderTest = @findKeywords
    end
    properties(TestParameter)
        method = {"bagOfWords", "ChatGPT"} 
        page = {"https://www.example.com"}
        maxKeywords = {5}
    end

    methods(Test)

        function testOutput(test, page)           
            [words, count] = test.funcUnderTest(page);
            test.verifyEqual(numel(words), numel(count));
            test.verifyTrue(isnumeric(count), "Count is not numeric")
        end

        function testMethod_NeedsAPIKey(test, page, method, maxKeywords)
            words = test.funcUnderTest(page, method=method, maxKeywords=maxKeywords);
            test.verifyEqual(numel(words), maxKeywords);
        end
    end
end
