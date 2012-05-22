#!/bin/bash

# Must pass new title
if [[ -z "$*" ]]; then echo "Usage: $0 TITLE"; exit 1; fi;

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../_posts"

LASTPOST=$(ls -1r $DIR/ | head -n 1);

DATE=$(echo "$LASTPOST" | sed -ne 's|^\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)-.*$|\1|p');
if [ ! "$DATE" ]; then DATE=$(date +%Y-%m-%d); fi

TITLE="$*"

echo $TITLE

NEWPOST="$DATE-"$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -e "s/[^a-z0-9_]\+/-/g")".md"

echo "$LASTPOST => $NEWPOST";

FULLNAME="$DIR/$NEWPOST"

# Dont overwrite existing files
if [[ -e "$FULLNAME" ]]; then echo "!!! File with new name already exists !!!"; exit 1; fi;

mv "$DIR/$LASTPOST" "$FULLNAME";


head "$FULLNAME" -n 2 | grep -qe '---'

if [[ $? -ne 0 ]]; then  
  echo "new frontmatter"
  # No FrontMatter. Add it.
  sed -i "1i ---\nlayout: post\ntitle: ""$TITLE""\n---\n" "$FULLNAME";
else
  echo "replacing frontmatter"
  # FrontMatter exists. Just replace title
  sed -i -e "s/^title: .*$/title: \"$TITLE\"/" "$FULLNAME";
fi
