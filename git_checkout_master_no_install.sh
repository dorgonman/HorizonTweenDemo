#!/bin/sh
set -e
git checkout -f master
git pull --prune
git submodule foreach --recursive "git checkout -f master"
git submodule foreach --recursive "git pull --prune"
