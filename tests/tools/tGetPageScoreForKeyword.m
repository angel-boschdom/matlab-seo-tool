classdef tGetPageScoreForKeyword < matlab.unittest.TestCase
    % Unit tests for getPageScoreForKeyword
      
    properties
        funcUnderTest = @getPageScoreForKeyword
    end
    properties(TestParameter)
        method = {"Keyword Density"} 
        page = {"https://www.mathworks.com/help/matlab/"}
        keyword = {"matlab", "potato"}
    end

    methods(Test)

        function testOutput(test, page, keyword)
            
            score = test.funcUnderTest(page,keyword);
            test.verifyLength(score,1);
            test.verifyTrue(isnumeric(score), "Score is not numeric")

        end

        function testOutputIsReasonable(test)
            matlabDocPage = "https://www.mathworks.com/help/matlab/";
            matlabScore = test.funcUnderTest(matlabDocPage,"matlab");
            potatoScore = test.funcUnderTest(matlabDocPage,"potato");
            test.verifyGreaterThan(matlabScore,potatoScore);
        end

        function testOutputIsNormalized(test, page, keyword)
            score = test.funcUnderTest(page,keyword);
            test.verifyGreaterThanOrEqual(score,0);
            test.verifyLessThanOrEqual(score,1);
        end

        function testOutput_Negative(test)
            
            invalidPage = "<dummypage>";
            aKeyword = "hola";
            test.verifyError(@() test.funcUnderTest(invalidPage,aKeyword), ...
                'MATLAB:webservices:ExpectedProtocol')
            
        end

        function testMethodOption(test,method)
            
            score = test.funcUnderTest(test.page{1}, test.keyword{1}, ...
                "method", method);
        end

        function testMethodOptionAlternativeSyntax(test,method)
            
            score = test.funcUnderTest(test.page{1}, test.keyword{1}, ...
                method=method);
        end

        function testMethodOption_Negative(test)

            invalidMethod = "<dummyMethod>";
            test.verifyError(@() test.funcUnderTest(test.page{1}, test.keyword{1}, ...
                 method=invalidMethod), ...
                'getPageScoreForKeyword:invalidMethod');
            
        end
    end
end
