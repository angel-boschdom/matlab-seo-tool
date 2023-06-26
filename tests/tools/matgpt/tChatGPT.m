classdef tChatGPT < matlab.unittest.TestCase
    % Unit tests for matgpt/helpers/chatGPT.m
      
    properties
        objUnderTest = @chatGPT
        role = "You are a text scorer. I send you a prompt and your output is only one number between 0 and 100."
        firstPrompt = {"My next prompt is the text content of a webpage. Your output is only one number between 0 and 100. The number represents how good the webpage is in terms of search engine visibility and ranking. 0 is the minimum score and 100 is the maximum score. It is very important that you only output the number and nothing else. Do not explain your choice. Just tell me the number."};
    end
    properties(TestParameter)
        url = {"https://www.mathworks.com"};
        temperature = {0, 0.5, 1};
        max_tokens = {1000};
    end

    methods(Test)

        function testConstructor(test)
            test.verifyWarningFree(@() test.objUnderTest(), "A chatGPT instance could not be created.");
        end

        function testOutput_NeedsAPIKey(test, temperature, max_tokens, url)
            
            scorer = test.objUnderTest();
            scorer.temperature = temperature;
            scorer.max_tokens = max_tokens;
            scorer.role = test.role;

            html = webread(url);
            str = extractHTMLText(html);
            scorer.chat(test.firstPrompt); % required for setting up the scorer bot
            answer = scorer.chat(str); % actual answer
            scorevalue = str2double(answer);

            test.verifyTrue(isnumeric(scorevalue), "Score provided is not a number.")

        end
    end
end
