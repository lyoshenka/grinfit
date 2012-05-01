#!/bin/bash

if [ -z "$*" ]; then
  echo "Need a post title";
  exit 1;
fi

TITLE=`echo "$*" | tr '[:upper:]' '[:lower:]' | sed -e "s/[^a-z0-9_]\+/-/g"`

FILENAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../_posts/$(date +%Y-%m-%d)-$TITLE".md
echo -e "---\nlayout: post\ntitle: \"$*\"\n---\n\n" >> $FILENAME
vi $FILENAME
