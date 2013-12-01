#! /bin/bash

PANDOC="pandoc --smart -f markdown --standalone  --template=template.html \
       --css=/css/style.css --include-before-body=./header.html \
       --include-after-body=./footer.html"

for file in $(find . -type f -name "*.md"); do
    html="${file%.md}.html"
    eval "$PANDOC" -o "$html" "$file"
done

# template.html was modified from:
# https://github.com/jgm/pandoc-templates/blob/master/default.html5
#
# The special variables are described here:
# http://johnmacfarlane.net/pandoc/demo/example9/templates.html
#