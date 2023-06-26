classdef SimpleSearchEngine < InternetSearchEngine
    %SIMPLESEARCHENGINE API-free, simple search engine by injecting
    % the searchword in https://www.google.com/search?q=
    
    methods
        function data = search(obj,searchString)
            %SEARCH Perform a search
            arguments (Input)
                obj SimpleSearchEngine %#ok<INUSA>
                searchString (1,1) string
            end
            arguments (Output)
                data    (1,1) struct
            end
            listOfURLs = searchInGoogle(searchString);
            data = convertToDataStruct(listOfURLs);
        end
    end
end

function listOfURLs = searchInGoogle(searchString)
    % MATLAB function that runs a Google search of the search sentence
    % contained in the "searchString" input argument and returns a list of
    % URLs that Google found in the search

    % Replace spaces in the search sentence with '%20' to form a valid URL
    searchString = strrep(searchString, ' ', '+');

    % Construct the Google search URL
    googleURL = strcat('https://www.google.com/search?q=', searchString);

    % Send a GET request to the Google search URL
    options = weboptions('Timeout', 10); % Set timeout to 10 seconds
    response = webread(googleURL, options);

    % Extract the URLs from the response
    urlPattern = 'https?://[^"%?]*';
    urls = regexp(response, urlPattern, 'match');

    % Remove unnecessary substrings from the URLs
    listOfURLs = cellfun(@(x) extractValidURL(x), urls, 'UniformOutput', false);

    % Remove duplicate URLs
    listOfURLs = unique(listOfURLs);

    % Remove empty URLs
    listOfURLs = listOfURLs(~cellfun('isempty', listOfURLs));

    % Convert to string column vector
    listOfURLs = string(listOfURLs');
end

function validURL = extractValidURL(url)
    % Extract the valid part of the URL by removing unnecessary substrings
    endIdx = strfind(url, '&');
    validURL = url(1:endIdx-1);
end

function data = convertToDataStruct(listOfURLs)
    data = struct();
    for idxItem = numel(listOfURLs):-1:1
        thisItem = struct();
        thisItem.link = listOfURLs(idxItem);
        data.items{idxItem,1} = thisItem;
    end
    
end