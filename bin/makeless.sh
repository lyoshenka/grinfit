#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..";
cd $DIR
node /home/grin/code/github/less.js/bin/lessc -x style.less > style.css
