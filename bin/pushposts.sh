#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../_posts";
cd "$DIR"
git add -A . && git commit -m "New post" && git push heroku 2>>../err >>../log
