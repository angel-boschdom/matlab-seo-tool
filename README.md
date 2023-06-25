# **Website Ranking with MATLAB®**

Automate website ranking and analysis using MATLAB® command-line interfaces for internet search engines.

## Improve your Website Ranking with MATLAB®

This repository provides a solution for automating website ranking and analysis using MATLAB®. By leveraging command-line interfaces of popular internet search engines, you can easily retrieve information about the ranking of your website in search results.

## Examples

### Check if your website is in the top 10 Google search results

To evaluate the effectiveness of your website's Search Engine Optimization (SEO), you can use your Google Programmable Search Engine API key to check if your website appears in the top search results for a specific keyword.

```matlab
googleEngine = googleapi.SearchEngine(); % class included in this repository
keyword = "matlab online"; % search word

websites = getTopSitesInBrowserSearch(keyword, googleEngine, 'maxSites', 10);

disp(websites)
```
The above example demonstrates how to retrieve the top 10 search results from Google for the keyword "matlab online". By executing the code, you will obtain a list of websites that rank in the top search results. This information can provide valuable insights into your website's visibility and SEO performance.

Feel free to explore the repository and adapt the code to suit your specific needs.

## Requirements

To run the code in this repository, you need the following:

 - [MATLAB®](https://www.mathworks.com/products/matlab.html) release R2022a or newer.
 - Google Programmable Search Engine API key

## Setup 

- Download the files or clone the repository to your local machine.
- Open the project file *WebsiteRanking.prj* to setup the project.
- Open and read the *examples/GoogleTop10.mlx* Live Script for a short demo.

## Contributing

Contributions to this repository are welcome. If you have any ideas or improvements, feel free to submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for more information.