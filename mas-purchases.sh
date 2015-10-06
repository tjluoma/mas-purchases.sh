#!/bin/zsh -f
# Purpose: Take HTML of Mac App Store Purchased page and convert it an alphabetical list (HTML page and MultiMarkdown)
#
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2015-10-05

NAME="mas-purchases"

LC_ALL='C'

function die
{
	echo "$NAME: $@"
	exit 1
}

BROWSER='Safari'

MMD="$HOME/Desktop/$NAME.mmd"

HTML="$HOME/Desktop/$NAME.html"

if [ -e "$HOME/.path" ]
then
	source "$HOME/.path"
else
	PATH=/usr/local/scripts:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin
fi

zmodload zsh/datetime

TIME=`strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS"`

TODAY=`strftime "%Y/%m/%d" "$EPOCHSECONDS"`


function timestamp { strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS" }

FILE="$HOME/Library/Containers/com.apple.appstore/Data/Library/Documentation/pageSource.html"

if [ ! -e "$FILE" ]
then
	echo "$NAME: No file found at $FILE"
	exit 1
fi

TEMPFILE="$HOME/Desktop/${NAME}.${TIME}.$$.$RANDOM"

rm -f "$TEMPFILE"

touch "$TEMPFILE"

cat "$FILE" \
| sed "1,/\<table aria-label='Purchased'\>/d" \
| sed '1,/<tbody>/d' \
| sed '/<\/tbody>/,$d' \
| tr -s '\012' ' ' \
| sed 's#<tr #\
\
<tr #g' \
| egrep -i '[a-z]' \
| while read line
do

	###########################################################################

	APP_IMAGE=`echo "$line" | tr ' |"' '\012' | fgrep 'icon128.png' |  sed 's#icon128.png.*#icon128.png#g ; s#.*http://a1.mzstatic.com#http://a1.mzstatic.com#g' `

	[[ "$APP_IMAGE" == "" ]] && die "APP_IMAGE is empty\n$line"

	###########################################################################

	APP_URL=`echo "$line" |  sed 's#.*https://macappsto.re/us/#https://macappsto.re/us/#g ; s/\&\#34\;.*//g' `

	[[ "$APP_URL" == "" ]] && die "APP_URL is empty\n$line"

	###########################################################################

	APP_NAME=`echo "$line" | sed 's#.*<h2>##g; s#</h2>.*##g' | sed 's#<a href=.*">##g; s#</a>##g ; s#<div>##g; s#</div>##g; s#\&amp\;#\&#g'`

	[[ "$APP_NAME" == "" ]] && die "APP_NAME is empty\n$line"

	###########################################################################

	PURCHASE_DATE=`echo "$line" | sed 's#.*</ul> </td> <td> ##g ; s# </td>.*##g'`

	[[ "$PURCHASE_DATE" == "" ]] && die "PURCHASE_DATE is empty\n$line"

	###########################################################################

	DEVELOPER=`echo "$line" | sed 's#.*</h2></li><li>##g ; s#</li>.*##g'`

	[[ "$DEVELOPER" == "" ]] && die "DEVELOPER is empty\n$line"

	###########################################################################

	echo "![$APP_NAME]($APP_IMAGE) [$APP_NAME]($APP_URL) by $DEVELOPER (Purchased $PURCHASE_DATE)" >> "$TEMPFILE"

done

PAGE_TITLE="Mac App Store Purchases (as of $TODAY)"

echo "Title: $PAGE_TITLE
XHTML Header: 	<style>img { vertical-align: middle; }</style>


# $PAGE_TITLE #


" > "$MMD"

sort --ignore-case "$TEMPFILE" | egrep -i '[a-z]' | sed G >> "$MMD"

if (( $+commands[multimarkdown] ))
then

	multimarkdown --to=html --notes --smart --process-html --output="$HTML" "$MMD"

	open -a "$BROWSER" "$HTML"

fi

mv -f "$TEMPFILE" "$HOME/.Trash/"

exit 0
#
#EOF
