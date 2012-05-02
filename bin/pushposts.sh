#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../";
LOCKFILE="last.lck"
NOW=$(date +%s)
TIMEOUT=30 # so we only push once every 30 seconds

# keep in mind that this lock is not reliable. make sure that in incron, we use solo.pl

cd "$DIR"

echo "$(date +%c) $@" >> log

#if [ ! -e "$LOCKFILE" ] || (("$NOW" - $(cat "$LOCKFILE") >= "$TIMEOUT")) ; then
#  git add -A _posts/ && git commit -m "New post" && git push heroku >> log
#  echo "$NOW" > "$LOCKFILE"
#fi
