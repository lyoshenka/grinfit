#!/bin/bash

DIR='_posts';
vi "$DIR/$(ls -1r $DIR/ | head -n 1)";
