#!/usr/bin/env bash

cd /home/jonathan/dotfiles

git pull origin master

stow */

echo "Pushing to git"
git add .
git commit -m "Cron-push"
git push origin master

echo "Finished!"
