#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if [[ "$@" =~ \.md$ ]] ; then
  # Only run pushposts if its not already running
  $DIR/bin/solo.pl -port=44009 -silent $DIR/pushposts.sh
fi
