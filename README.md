# **Website Ranking with MATLAB®**

Use the power of MATLAB® to automate website ranking and analysis, using internet search engines.

## Examples

### Is your website in the top 10 Google search results?

Use your Google Programmable Search Engine API key to check the top search results for a keyword.
This can help you understand if your website has a good Search Engine Optimization (SEO).

```matlab
googleEngine = googleapi.SearchEngine(); % class included in this repository
keyword = "pmsm modeling"; % search word

websites = getTopSitesInBrowserSearch(keyword, googleEngine, 'maxSites', 10);

disp(websites)
```

Command Window output:

```matlab
"https://www.mathworks.com/help/sps/ref/pmsm.html"
"https://ieeexplore.ieee.org/document/9176"
"https://liu.diva-portal.org/smash/get/diva2:1671362/FULLTEXT01.pdf"
"https://ieeexplore.ieee.org/document/25541"
"https://www.researchgate.net/file.PostFileLoader.html?id=55bd34a26307d936878b458f&assetKey=AS%3A273823490871303%401442296015731"
"https://odr.chalmers.se/server/api/core/bitstreams/d0f2c108-0ca7-4185-9935-09df731f479a/content"
"https://www.slideshare.net/bibhuprasadganthia/modelling-of-pmsm"
"https://ipsj.ixsq.nii.ac.jp/ej/?action=repository_uri&item_id=210331&file_id=1&file_no=1"
"http://www.irphouse.com/ijee/ijeev7n3_05.pdf"
"https://stemgateway.nasa.gov/public/s/course-offering/a0Bt0000004lCKHEA2/permanent-magnet-synchronous-motor-pmsm-modeling-and-pmsm-controls-modeling"
```
