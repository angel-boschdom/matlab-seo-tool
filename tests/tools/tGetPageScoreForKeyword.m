classdef tGetPageScoreForKeyword < matlab.unittest.TestCase
    % Unit tests for getPageScoreForKeyword
      
    properties
        funcUnderTest = @getPageScoreForKeyword
    end
    properties(TestParameter)
        method = {"KeywordDensity", "ChatGPT"} 
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

        function testNormalizedOption(test, page, keyword)
            engine = hSearchEngineMockup("GoogleEngineSearchSample1_CellItems.mat");
            score = test.funcUnderTest(page,keyword,'engine',engine, 'normalize', true);
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

        function testKeywordDensityMethod(test)
            verifyMatlabHasGreaterScoreThanPotatoForMethod(test, "KeywordDensity")
        end

        function testChatGPTMethod_NeedsAPIKey(test)
            verifyMatlabHasGreaterScoreThanPotatoForMethod(test, "ChatGPT")
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

% Helper function
function verifyMatlabHasGreaterScoreThanPotatoForMethod(test, methodName)
    engine = hSearchEngineMockup("GoogleEngineSearchSample2_CellItems.mat");
    matlabDocPage = "https://www.mathworks.com/help/matlab/";
    matlabScore = test.funcUnderTest(matlabDocPage,"matlab",engine=engine,method=methodName);
    potatoScore = test.funcUnderTest(matlabDocPage,"potato",engine=engine,method=methodName);
    test.verifyGreaterThan(matlabScore,potatoScore);
end
