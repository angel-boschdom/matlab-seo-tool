# **MATLAB SEO Tool: Boost Keyword Research, Website Ranking, and Competitor Analysis**

Automate [search engine optimization (SEO)](https://en.wikipedia.org/wiki/Search_engine_optimization) tasks with MATLAB® to enhance your website's visibility and drive organic traffic.

## Improve your Website Ranking with MATLAB®

![](/media/GoogleTop10ExampleTable.PNG)

This repository provides a solution for automating website ranking and keyword analysis using [MATLAB®](https://www.mathworks.com/products/matlab.html). 
By leveraging MATLAB's command-line interfaces with popular search engines, you can effortlessly:
1. Retrieve information about your ranking in search results.
2. Compute the SEO score of your webpage with well-known methods.
3. Research your competitor's keywords with website crawling.

## Examples

### Check if your website is in the top 10 Google search results

Evaluate the effectiveness of your website's SEO by using the [Google Programmable Search Engine](https://programmablesearchengine.google.com/about/) API key to check if your website appears in the top search results for a specific keyword.

```matlab
googleEngine = googleapi.SearchEngine(); % class included in this repository
keyword = "matlab online"; % search word

websites = getTopSitesInBrowserSearch(keyword, googleEngine, 'maxSites', 10)
```
The above example demonstrates how to retrieve the top 10 search results from Google for the keyword "matlab online". By executing the code, you will obtain a list of websites that rank in the top search results. This information can provide valuable insights into your website's visibility and SEO performance.

### Compute the SEO score of your website

Use the functions included in this repository to compute your website's SEO score for a specific keyword, using a variety of scoring methods.

```matlab
website = "https://www.mathworks.com/";
keyword = "artificial intelligence";
score1 = getPageScoreForKeyword(website, keyword, method="KeywordDensity")
score2 = getPageScoreForKeyword(website, keyword, method="BacklinksFromTop10")
```

You can use [ChatGPT](https://openai.com/chatgpt) as a scoring method. 
The tool uses [MatGPT](https://www.mathworks.com/matlabcentral/fileexchange/126665-matgpt/) to connect MATLAB to the [OpenAI API](https://platform.openai.com/docs/api-reference) and ask ChatGPT for a SEO score.

```matlab
score3 = getPageScoreForKeyword(website, keyword, method="ChatGPT")
```

Feel free to explore the repository and adapt the code to suit your specific needs.

## Requirements

To run the code in this repository, you need the following:

 - [MATLAB®](https://www.mathworks.com/products/matlab.html) release R2022b or newer.
 - [Google Programmable Search Engine](https://developers.google.com/custom-search) API key

## Setup 

1. Download the content of this repository.
2. Launch MATLAB from your desktop or [MATLAB Online](https://www.mathworks.com/products/matlab-online.html) from your browser.
3. Before using, set an environment variable with your Google Custom Search Engine ID and API key.

```matlab
setenv("GOOGLE_SEARCH_ENGINE_ID", "your-search-engine-id-here");
setenv("GOOGLE_SEARCH_ENGINE_API_KEY", "your-api-key-here");
```
4. Open the project file *WebsiteRanking.prj* to setup the project.
5. Open the *examples/GoogleTop10.mlx* Live Script for a short demo.

## Contributing

Contributions to this repository are welcome. If you have any ideas or improvements, feel free to submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for more information.