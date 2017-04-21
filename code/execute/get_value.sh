#!/bin/sh
echo "$(cat $1 | grep "\"$2\""  | cut -d ':' -f 2- | sed -e 's/^[ \t]*//' -e 's/"//' -e 's/"//' -e 's/,//')"
rm $1