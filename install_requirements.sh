#!/usr/bin/env bash

#sudo apt update
#
sudo apt install -y git
sudo apt install -y stow # needed for dotfile management
sudo apt install -y tmux
sudo apt install -y ripgrep
sudo apt install -y wget tar curl
# clipboard stuff for x11 and wayland
sudo apt install xclip wl-clipboard
# From fixit github
echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://eugene-babichenko.github.io/fixit/ppa ./" | sudo tee /etc/apt/sources.list.d/fixit.list > /dev/null
sudo apt update
sudo apt install fixit
# install node and npm
curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt install -y nodejs
# Chown npm and node modules
sudo chown -R $USER ~/.npm
sudo chown -R $USER /usr/lib/node_modules/

# install tldr
sudo npm install -g tldr


# Install nvim in Documents because why not
# install nvim from latest stable, symlink to /usr/local/bin
NVIM_VERSION=$(git ls-remote --refs --tags git@github.com:neovim/neovim.git | cut --delimiter='/' --fields=3 | tr '-' '~' | sort --version-sort | tail --lines=1)
wget https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz -O ~/Downloads/nvim-linux64.tar.gz
tar xf ~/Downloads/nvim-linux64.tar.gz --directory=~/Documents/nvim-linux64/
# symlink to /usr/local/bin/
sudo ln -s ~/Documents/nvim-linux64/bin/nvim /usr/local/bin/nvim

git submodule update

# rename stuff before stow
mv ~/.tmux.conf ~/.tmux.old.conf
mv ~/.config/nvim/ ~/.config/nvim.old.bak
mv ~/.bashrc ~/.bashrc.old.bak
stow tmux
stow nvim
stow bash
stow scripts
