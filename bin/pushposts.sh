#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..";
cd "$DIR"
git add -A _posts/ && git commit -m "New post" && git push && git push heroku
