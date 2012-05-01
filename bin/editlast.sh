#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../_posts";
vi "$DIR/$(ls -1r $DIR/ | head -n 1)";
