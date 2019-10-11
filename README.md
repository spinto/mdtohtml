Small bash script to convert markdown to HTML (using [Showdown](http://showdownjs.com/))

The HTML can be then rendered to PDF via [wkhtmltopdf](https://wkhtmltopdf.org/)

# Installation
All the software dependencies are included in the _js_ folder.

To install the software you can:
 - Download it into your /usr/local/ folder and then link it in the /usr/local/bin folder

```
VERSION=0.2
curl https://github.com/spinto/mdtohtml/archive/v$VERSION.tar.gz | sudo tar xvz -C /usr/local/
sudo ln -s /usr/local/mdtohtml-$VERSION/mdtohtml.sh /usr/local/bin/mdtohtml
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
