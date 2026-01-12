#!/usr/bin/env bash

backup_if_not_symlink() {
    if [ -f "$1" ] && [ ! -L "$1" ]; then
        mv "$1" "$1.old.bak"
        echo "Backed up $1 to $1.old.bak"
    else
        echo "$1 is already symlinked or does not exist"
    fi
}

backup_if_not_symlink ~/.tmux.conf
backup_if_not_symlink ~/.config/nvim
backup_if_not_symlink ~/.config/polybar
backup_if_not_symlink ~/.bashrc
backup_if_not_symlink ~/.gitconfig
backup_if_not_symlink ~/.bash.d

# Stow all
for dir in tmux nvim bash scripts kitty git picom i3 polybar; do
    stow -t ~ "$dir"
done
# reload tmux
tmux source ~/.tmux.conf || true
