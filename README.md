# **Website Ranking with MATLAB®**

Use the power of MATLAB® to automate website ranking and analysis, using internet search engines.

## Examples

### Is your website in the top 10 Google search results?

Use your Google Programmable Search Engine API key to check the top search results for a keyword.
This can help you understand if your website has a good Search Engine Optimization (SEO).

```matlab
googleEngine = googleapi.SearchEngine(); % class included in this repository
keyword = "matlab online"; % search word

websites = getTopSitesInBrowserSearch(keyword, googleEngine, 'maxSites', 10);

disp(websites)
```

Command Window output:

```matlab
    "https://www.mathworks.com/products/matlab-online.html"
    "https://matlab.mathworks.com/"
    "https://www.mathworks.com/"
    "https://in.mathworks.com/products/matlab-online.html"
    "https://matlabacademy.mathworks.com/"
    "https://es.mathworks.com/products/matlab-online.html"
    "https://se.mathworks.com/help/matlab-online-server/ug/matlab-online.html"
    "https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted"
    "https://uk.mathworks.com/products/matlab-online.html"
    "https://la.mathworks.com/matlabcentral/answers/482517-how-to-download-file-in-online-matlab"
```
