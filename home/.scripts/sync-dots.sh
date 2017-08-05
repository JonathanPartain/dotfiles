#!/usr/bin/env bash
echo "Synching i3 directory... 1/5"
rsync -av /home/jonathan/.config/i3/ /home/jonathan/dotfiles/home/.config/i3/

echo "Synching polybar directory... 2/5"
rsync -av /home/jonathan/.config/polybar/ /home/jonathan/dotfiles/home/.config/polybar/

echo "Synching scripts directory... 3/5"
rsync -av /home/jonathan/.scripts/ /home/jonathan/dotfiles/home/.scripts/

echo "Synching vimrc file... 4/5"
rsync -av /home/jonathan/.vimrc /home/jonathan/dotfiles/home/.vimrc

echo "Synching bashrc file... 5/5"
rsync -av /home/jonathan/.bashrc /home/jonathan/dotfiles/home/.bashrc

echo "Finished!"
