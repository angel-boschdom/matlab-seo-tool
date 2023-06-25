function score = getPageScoreForKeyword(url, keyword, options)
%GETPAGESCOREFORKEYWORD Get the SEO score of a website page for a
%specific keyword.
    
    arguments (Input)
        url             (1,1) string % page URL
        keyword         (1,1) string % search word
        options.method  (1,1) string = "Keyword Density" % Scoring method
    end
    arguments (Output)
        score           (1,1) double % page score
    end

    switch options.method
        case "Keyword Density"
            score = getKeywordDensityScore(url, keyword);
        case "Backlinks From Top 10"
            score = getBacklinksTop10Score(url, keyword);
        otherwise
            errID = "getPageScoreForKeyword:invalidMethod";
            msg = strcat(options.method, " is not a valid option. Specify a supported method.");
            ME = MException(errID,msg);
            throw(ME);
    end

end

function score = getKeywordDensityScore(url, keyword)
    % Implementation of the Keyword Density scoring method

    html = getHTML(url);

    % Convert HTML to lowercase for case-insensitive matching
    html = lower(html);

    % Count the number of occurrences of the keyword
    keywordCount = numel(strfind(html, lower(keyword)));

    % Calculate the score based on the keyword count
    score = keywordCount;

    % Normalize based on total number of words in the page
    numWords = numel(strsplit(html));
    score = score/numWords;

end

function score = getBacklinksTop10Score(url, keyword)
    % Implementation of the Backlinks From Top 10 scoring method

    % 1) Find top 10 pages in a google search for keyword
    engine = googleapi.SearchEngine();
    top10 = getTopSitesInBrowserSearch(keyword, engine, maxSites=10);

    % 2) Count the number of times the url is linked in those top 10 pages.
    linkCount = 0;
    for idxSite = numel(top10):-1:1
        thisSite = top10(idxSite);
        links = findLinks(thisSite);
        linkCount = linkCount + sum(int32(contains(links, url)));
    end

    % 3) Normalize based on total number of words in the page
    html = getHTML(url);
    numWords = numel(strsplit(html));
    score = linkCount/numWords;
    
end

function html = getHTML(url)
    try
        html = webread(url);
    catch exc
        throwAsCaller(exc);
    end
end