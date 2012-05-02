#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
#LOCKFILE="last.lck"
#NOW=$(date +%s)
#TIMEOUT=30 # so we only push once every 30 seconds

# keep in mind that this lock is not reliable. make sure that in incron, we use solo.pl

#cd "$DIR"

#if [ ! -e "$LOCKFILE" ] || (("$NOW" - $(cat "$LOCKFILE") >= "$TIMEOUT")) ; then
#if [[ "$@" =~ \.md$ ]] ; then
  #/home/grin/bin/solo.pl -port=44009 -silent $DIR/pushposts.sh
  $DIR/pushposts.sh
#  echo "$NOW" > "$LOCKFILE"
#fi
