#!/bin/bash
#Create HTML files from Markdown text (offline, using showdown javascript library)

function usage(){
  echo "Usage:
  ${0##*/} [options] <input> [<output>]

where <input> is the input Markdown file and <output> is the output .html file [default same as input file
with extension replaced to .html]. The software will create an HTML file and install the HTML dependencies
in the same folder where the output .html file is located.

Options are:
 -h | --help          Display this help
 -I | --internal-dep  Include dependencies in the HTML (in script/style tags)
 -E | --external-dep  Include dependencies as remote links
"
  exit 1
}

function error(){
  echo "ERROR: $2"
  exit $1
}

_JS_DEPENDENCIES="local"
_INPUT_FILE=
_OUTPUT_FILE=

#Parse arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
   -h | --help) usage ;;
   -I | --internal-dep) _JS_DEPENDENCIES="internal"; shift 1;;
   -E | --external-dep) _JS_DEPENDENCIES="external"; shift 1;;
   *) if [[ -z "$_INPUT_FILE" ]]; then
        _INPUT_FILE="$1"
      elif [[ -z "$_OUTPUT_FILE" ]]; then
        _OUTPUT_FILE="$1"
      else
        error 11 "Too many input arguments"
      fi
      shift 1
    ;;
  esac
done

#Check arguments
[[ -z "$_INPUT_FILE" ]] && usage
[[ -z "$_OUTPUT_FILE" ]] && _OUTPUT_FILE="${_INPUT_FILE%.*}.html"
[[ -e "$_INPUT_FILE" ]] || error 2 "Input file $_INPUT_FILE does not exist"
touch "$_OUTPUT_FILE" &>/dev/null || error 2 "Cannot write to $_OUTPUT_FILE"
OUTFOLDER="${_OUTPUT_FILE%/*}"; [[ "$OUTFOLDER" == "$_OUTPUT_FILE" ]] && OUTFOLDER="."; [[ -z "$OUTFOLDER" ]] && OUTFOLDER="."
APPNAME="`readlink -f ${BASH_SOURCE[0]}`"
APPFOLDER="${APPNAME%/*}"; [[ "$APPFOLDER" == "$0" ]] && APPFOLDER="."; [[ -z "$APPFOLDER" ]] && APPFOLDER="."

#Generate HTML
cat <<EOF > $_OUTPUT_FILE
<!DOCTYPE html>
<html>
<head>
EOF

#Insert styles
if [[ $_JS_DEPENDENCIES == "local" ]]; then
  mkdir -p $OUTFOLDER/css
  cp -r $APPFOLDER/dep/css/*.css $OUTFOLDER/css/
  for css in $OUTFOLDER/css/*.css; do
    cssname="${css##*/}"
    echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/$cssname\">" >> $_OUTPUT_FILE
  done
elif [[ $_JS_DEPENDENCIES == "internal" ]]; then
  for css in $APPFOLDER/dep/css/*.css; do
    echo "<style>" >> $_OUTPUT_FILE
    cat $css >> $_OUTPUT_FILE
    echo "</style>" >> $_OUTPUT_FILE
  done
elif [[ $_JS_DEPENDENCIES == "external" ]]; then
  cat <<EOF >> $_OUTPUT_FILE
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.5.3/css/foundation.min.css">
<link rel="stylesheet" type="text/css" href="http://demo.showdownjs.com/css/style.css">
EOF
else
  error 5 "Internal inconsistency. This should never happen!"
fi

#Insert MD file
echo "</head>
<body>
<textarea id=\"sourceTA\" style=\"display: none;\">" >> $_OUTPUT_FILE
cat $_INPUT_FILE >> $_OUTPUT_FILE
echo "</textarea>" >> $_OUTPUT_FILE

#Insert scripts
if [[ $_JS_DEPENDENCIES == "local" ]]; then
  mkdir -p $OUTFOLDER/js
  cp -r $APPFOLDER/dep/js/*.js $OUTFOLDER/js/
  for css in $OUTFOLDER/js/*.js; do
    cssname="${css##*/}"
    echo "<script src=\"js/$cssname\"></script>" >> $_OUTPUT_FILE
  done
elif [[ $_JS_DEPENDENCIES == "internal" ]]; then
  for css in $APPFOLDER/dep/js/*.js; do
    echo "<script>" >> $_OUTPUT_FILE
    cat $css >> $_OUTPUT_FILE
    echo "</script>" >> $_OUTPUT_FILE
  done
elif [[ $_JS_DEPENDENCIES == "external" ]]; then
  cat <<EOF >> $_OUTPUT_FILE
<script src="https://cdn.rawgit.com/showdownjs/showdown/1.9.1/dist/showdown.min.js"></script>
EOF
else
  error 5 "Internal inconsistency. This should never happen!"
fi

cat << EOF >> $_OUTPUT_FILE
<script>
function run() {
  var text = document.getElementById('sourceTA').value;
  var converter = new showdown.Converter({tables: true, strikethrough: true, ghCompatibleHeaderId: true, simplifiedAutoLink: true, excludeTrailingPunctuationFromURLs: true, ghCodeBlocks: true, tasklists: true, ghMentions: false, ghMentionsLink: "",smartIndentationFix: true,simpleLineBreaks: true,emoji: true, underline: true});
  document.body.innerHTML = converter.makeHtml(text);
}
run();
</script>
</body>
</html>
EOF

#Completed
echo "Image $_OUTPUT_FILE written"

exit 0

