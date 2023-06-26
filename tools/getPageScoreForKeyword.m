function score = getPageScoreForKeyword(url, keyword, options)
%GETPAGESCOREFORKEYWORD Get the SEO score of a website page for a
%specific keyword.
    
    arguments (Input)
        url               (1,1) string % page URL
        keyword           (1,1) string % search word
        options.method    (1,1) string = "KeywordDensity" % Scoring method
        options.engine    (1,1) InternetSearchEngine;
        options.normalize (1,1) logical = false;
    end
    arguments (Output)
        score           (1,1) double % page score
    end

    switch options.method
        case "KeywordDensity"
            score = getKeywordDensityScore(url, keyword);
            if options.normalize
                if isfield(options, "engine")
                    engine = options.engine;
                else
                    engine = googleapi.SearchEngine(); % default engine
                end
                top10 = getTopSitesInBrowserSearch(keyword, engine, maxSites=10);
                numSites = numel(top10);
                sumScoreTop10 = 0;
                for idxSite = 1:numSites
                    thisScore = getKeywordDensityScore(top10(idxSite), keyword);
                    sumScoreTop10 = sumScoreTop10 + thisScore;
                end
                avgScoreTop10 = sumScoreTop10/numSites;
                if avgScoreTop10>0
                    score = score/avgScoreTop10;
                else
                    score = 0;
                end
            end
        case "BacklinksFromTop10"
            if isfield(options, "engine")
                engine = options.engine;
            else
                engine = googleapi.SearchEngine(); % default engine
            end
            top10 = getTopSitesInBrowserSearch(keyword, engine, maxSites=10);
            score = countBacklinksFromWebpages(url, top10);
            if options.normalize
                totalBacklinksBetweenTop10 = 0;
                numSites = numel(top10);
                for idxSite = 1:numSites
                    numLinks = countBacklinksFromWebpages(top10(idxSite), top10);
                    totalBacklinksBetweenTop10 = totalBacklinksBetweenTop10 + numLinks;
                end
                avgScoreTop10 = totalBacklinksBetweenTop10/numSites;
                if avgScoreTop10>0
                    score = score/avgScoreTop10;
                else
                    score = 0;
                end
            end
        case "ChatGPT"
            score = getChatGPTScore(url, keyword);
            if options.normalize
                if isfield(options, "engine")
                    engine = options.engine;
                else
                    engine = googleapi.SearchEngine(); % default engine
                end
                top10 = getTopSitesInBrowserSearch(keyword, engine, maxSites=10);
                numSites = numel(top10);
                sumScoreTop10 = 0;
                for idxSite = 1:numSites
                    thisScore = getChatGPTScore(top10(idxSite), keyword);
                    sumScoreTop10 = sumScoreTop10 + thisScore;
                end
                avgScoreTop10 = sumScoreTop10/numSites;
                if avgScoreTop10>0
                    score = score/avgScoreTop10;
                else
                    score = 0;
                end
            end
        otherwise
            errID = "getPageScoreForKeyword:invalidMethod";
            msg = strcat(options.method, " is not a valid option. Specify a supported method.");
            ME = MException(errID,msg);
            throw(ME);
    end

end

function keywordCount = getKeywordDensityScore(url, keyword)
    % Implementation of the KeywordDensity scoring method

    html = getHTML(url);

    % Convert HTML to lowercase for case-insensitive matching
    html = lower(html);

    % Count the number of occurrences of the keyword
    keywordCount = numel(strfind(html, lower(keyword)));

end

function linkCount = countBacklinksFromWebpages(url, webpages)
    % Count the number of times the url is linked in the webpages
    linkCount = 0;
    for idxSite = numel(webpages):-1:1
        thisSite = webpages(idxSite);
        links = findLinks(thisSite);
        linkCount = linkCount + sum(int32(contains(links, url)));
    end    
end

function scoreValue = getChatGPTScore(url, keyword)

    scorer = chatGPT();
    scorer.temperature = 0;    
    scorer.role = "You are a text scorer. I send you a prompt and your output is only one number between 0 and 100";
    prompt = strcat('My next prompt is the text content of a webpage. Your output is only one number between 0 and 100.', ...
                    'The number represents how good the webpage is in terms of search engine visibility and ranking for a particular keyword. ', ...
                    '0 is the minimum score and 100 is the maximum score. It is very important that you only output the number and nothing else. ', ...
                    'Do not explain your choice. Just tell me the number. The keyword is "', keyword, '". What is the score?');
    html = getHTML(url);
    str = extractHTMLText(html);
    numWords = numel(strsplit(strcat(str,prompt)));
    scorer.max_tokens = numWords + 100;
    scorer.chat(prompt); % required for setting up the scorer bot
    answer = scorer.chat(str); % actual answer
    try
        scoreValue = str2double(answer);
    catch originalException
        throw(originalException); % TO DO: create an exception "ChatGPT failed to produce a valid score" and add the originalException as cause.
    end
end

function html = getHTML(url)
    try
        html = webread(url);
    catch exc
        throwAsCaller(exc);
    end
end