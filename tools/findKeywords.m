function [words, count] = findKeywords(url,options)
    arguments(Input)
        url (1,1) string % URL to search page for keywords
        options.maxKeywords (1,1) uint32 = 10;
        options.method (1,1) string = "bagOfWords" % keyword search method
    end
    arguments(Output)
        words (:,1) string % list of keywords found
        count (:,1) double % count of each keyword
    end

    switch options.method
        case "bagOfWords"
            [words, count] = findKeywordsWithBagOfWordsMethod(url, options.maxKeywords);
        case "textrankKeywords"
            [words, count] = findKeywordsWithTextRankMethod(url, options.maxKeywords);
        case "ChatGPT"
            words = findKeywordsWithChatGPT(url, options.maxKeywords);
            count = [];
        otherwise
            errID = "findKeywords:invalidMethod";
            msg = strcat(options.method, " is not a valid option. Specify a supported method.");
            ME = MException(errID,msg);
            throw(ME);
    end
end

function [words, count] = findKeywordsWithBagOfWordsMethod(url, numWords)
    html = webread(url);
    html = lower(html); % lowercase, for case-insensitive matching
    content = extractHTMLText(html);
    allWords = splitExcludingIrrelevantTokens(content);
    document = tokenizedDocument(strjoin(allWords, ' '));
    bag = bagOfWords(document);
    tbl = topkwords(bag, numWords);
    words = tbl.Word;
    count = tbl.Count;
end

function [words, score] = findKeywordsWithTextRankMethod(url, numWords)
    html = webread(url);
    html = lower(html); % lowercase, for case-insensitive matching
    content = strip(extractHTMLText(html));
    document = tokenizedDocument(content);
    tbl = textrankKeywords(document, "MaxNumKeywords",numWords);
    words = tbl.Keywords;
    score = tbl.Score;
end

function words = findKeywordsWithChatGPT(url, numKeywords)
    scorer = chatGPT();
    scorer.temperature = 0;    
    scorer.role = strcat('You are a search engine optimization (SEO) specialist and keyword identifier. I send you a text, and your output is a list of keywords.');
    prompt = strcat('My next prompt is the text content of a webpage. Your output is a list of the ', num2str(numKeywords), ' top keywords in the page. ', ...
                    'The keywords must be the best for SEO. Only show ', num2str(numKeywords), ' keywords exactly. Do not comment your response, start directly with the list.');
    html = webread(url);
    str = extractHTMLText(html);
    numWords = numel(strsplit(strcat(str,prompt)));
    scorer.max_tokens = numWords + numKeywords + 10;
    scorer.chat(prompt); % required for setting up the scorer bot
    answer = scorer.chat(str); % actual answer
    words = interpretChatGPTAnswer(answer);

end

function words = splitExcludingIrrelevantTokens(str)
    
    % Remove common tokens that are not meaningful for SEO
    excludedWords = [... 
        "and", "to", "the", "of", "in", "for", "is", "on", "it", "with", "that", ...
        "as", "at", "by", "from", "an", "or", "but", "not", "this", "be", "are", "you", ...
        "your", "we", "our", "us", "they", "them", "he", "him", "she", "her", "it", "its", ...
        "we", "we're", "you", "you're", "they", "they're", "their", "a", "an", "some", ...
        "any", "all", "every", "each", "many", "much", "few", "fewer", "most", "more", ...
        "such", "only", "just", "also", "now", "then", "so", "there", "here", "when", ...
        "where", "why", "how", "which", "what", "who", "whom", "whose", "has", "have", ...
        "had", "do", "does", "did", "will", "would", "should", "can", "could", "may", ...
        "might", "must", "shall", "should", "ought", "need", "dare", "isn't", "aren't", ...
        "wasn't", "weren't", "hasn't", "haven't", "hadn't", "doesn't", "don't", "didn't", ...
        "won't", "wouldn't", "shouldn't", "can't", "cannot", "couldn't", "mayn't", ...
        "mightn't", "mustn't", "shan't", "shouldn't", "oughtn't", "needn't", "daren't", ...
        ]; 
    
    excludedWordsPattern = sprintf('\\b(?:%s)\\b', strjoin(excludedWords, '|'));
    str = regexprep(str, excludedWordsPattern, '');
    words = split(str);
    words = words(~cellfun('isempty', words));
    words = string(words); % convert cell array to array of strings 
    words = setdiff(words,excludedWords);    
    charactersToRemove = [",", ";", ".", "®"];
    for idxChar = 1:numel(charactersToRemove)
        thisChar = charactersToRemove(idxChar);
        words = strip(words, thisChar); 
    end
    words(strlength(words)<2) = []; % remove one-character words
end

function words = interpretChatGPTAnswer(answer)

    % Split the string into individual words
    words = regexp(answer, '\n', 'split');
    
    % Remove the "1. ", "2. ", etc. 
    words = extractAfter(words, " ");
end