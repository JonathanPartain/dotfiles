#!/bin/zsh
file=$1
newname=${1:t:r}.out
gcc $1 -o $newname
