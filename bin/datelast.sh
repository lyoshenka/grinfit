#!/bin/bash

# Must pass date
if [[ -z "$*" ]]; then echo "Usage: $0 DATESTRING"; exit 1; fi;

DIR='_posts'
LASTPOST=$(ls -1r $DIR/ | head -n 1);
LASTTITLE=$(echo "$LASTPOST" | sed -ne 's|^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-\(.*\)$|\1|p');
NEWDATE=$(date +%Y-%m-%d -d "$*");

# Make sure date is valid. 
if [[ $? -ne 0 ]]; then  exit 1; fi;

NEWPOST="$NEWDATE-$LASTTITLE";
echo "$LASTPOST => $NEWPOST";

# Dont overwrite existing files
if [[ -e "$DIR/$NEWPOST" ]]; then echo "!!! File with new name already exists !!!"; exit 1; fi;

mv "$DIR/$LASTPOST" "$DIR/$NEWPOST";
