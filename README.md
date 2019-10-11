Small bash script to convert markdown to HTML (using [Showdown](http://showdownjs.com/))

The HTML can be then rendered to PDF via [wkhtmltopdf](https://wkhtmltopdf.org/)

# Installation
All the software dependencies are included in the _js_ folder.

To install the software you can:
 - Download it into your /usr/local/mdtohtml folder and then link it in the /usr/bin folder

```
cd /usr/local
sudo git clone https://github.com/spinto/mdtohtml
sudo ln -s /usr/local/mdtohtml/mdtohtml.sh /usr/bin/mdtohtml
```

# Usage:

```
Usage:
  mdtohtml.sh [options] <input> [<output>]

where <input> is the input Markdown file and <output> is the output .html file [default same as input file
with extension replaced to .html]. The software will create an HTML file and install the HTML dependencies
in the same folder where the output .html file is located.

Options are:
 -h | --help          Display this help
 -I | --internal-dep  Include dependencies in the HTML (in script/style tags)
 -E | --external-dep  Include dependencies as remote links
```
