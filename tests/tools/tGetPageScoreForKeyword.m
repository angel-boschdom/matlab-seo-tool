classdef tGetPageScoreForKeyword < matlab.unittest.TestCase
    % Unit tests for getPageScoreForKeyword
      
    properties
        funcUnderTest = @getPageScoreForKeyword
    end
    properties(TestParameter)
        method = {"KeywordDensity"} 
        page = {"https://www.mathworks.com/help/matlab/"}
        keyword = {"matlab", "potato"}
    end

    methods(Test)

        function testOutput(test, page, keyword)
            
            engine = hSearchEngineMockup("GoogleEngineSearchSample1_CellItems.mat");
            score = test.funcUnderTest(page,keyword,'engine',engine);
            test.verifyLength(score,1);
            test.verifyTrue(isnumeric(score), "Score is not numeric")

        end

        function testOutputIsReasonable(test)
            engine = hSearchEngineMockup("GoogleEngineSearchSample1_CellItems.mat");
            matlabDocPage = "https://www.mathworks.com/help/matlab/";
            matlabScore = test.funcUnderTest(matlabDocPage,"matlab",'engine',engine);
            potatoScore = test.funcUnderTest(matlabDocPage,"potato",'engine',engine);
            test.verifyGreaterThan(matlabScore,potatoScore);
        end

        function testOutputIsNormalized(test, page, keyword)
            engine = hSearchEngineMockup("GoogleEngineSearchSample1_CellItems.mat");
            score = test.funcUnderTest(page,keyword,'engine',engine);
            test.verifyGreaterThanOrEqual(score,0);
            test.verifyLessThanOrEqual(score,1);
        end

        function testOutput_Negative(test)
            
            engine = hSearchEngineMockup("GoogleEngineSearchSample1_CellItems.mat");
            invalidPage = "<dummypage>";
            aKeyword = "hola";
            test.verifyError(@() test.funcUnderTest(invalidPage,aKeyword,'engine',engine), ...
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
            engine = hSearchEngineMockup("GoogleEngineSearchSample1_CellItems.mat");
            invalidMethod = "<dummyMethod>";
            test.verifyError(@() test.funcUnderTest(test.page{1}, test.keyword{1}, ...
                 method=invalidMethod, engine=engine), ...
                'getPageScoreForKeyword:invalidMethod');
            
        end
    end
end
