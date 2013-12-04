#! /bin/bash

PANDOC="pandoc --smart -f markdown --standalone  --template=./_template.html \
       --css=/css/style.css --css=/css/github.css \
       --include-before-body=./_header.html \
       --include-after-body=./_footer.html"

for file in $(find . -type f -name "*.md"); do
    html="${file%.md}.html"
    echo "Processing $file"
    eval "$PANDOC" -o "$html" "$file"
done

# template.html was modified from:
# https://github.com/jgm/pandoc-templates/blob/master/default.html5
#
# The special variables are described here:
# http://johnmacfarlane.net/pandoc/demo/example9/templates.html
#
# This bash script was inspired by
# https://github.com/wcaleb/website/blob/master/pansite.sh
#
