#!/usr/bin/env bash
num=$((RANDOM % 2))

if [ $num -eq 1 ]
then
    echo "heads"
else
    echo "tails"
fi
