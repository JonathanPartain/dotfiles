#!/usr/bin/env bash

#sudo apt update
#
sudo apt install -y git
sudo apt install -y stow # needed for dotfile management
sudo apt install -y tmux
sudo apt install -y ripgrep
sudo apt install -y wget tar curl
sudo apt install -y fzf
# clipboard stuff for x11 and wayland
sudo apt install xclip wl-clipboard
# From fixit github
echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://eugene-babichenko.github.io/fixit/ppa ./" | sudo tee /etc/apt/sources.list.d/fixit.list > /dev/null
sudo apt update
sudo apt install fixit
# install node and npm
curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
rm nodesource_setup.sh
sudo apt install -y nodejs
# Chown npm and node modules
sudo chown -R $USER ~/.npm
sudo chown -R $USER /usr/lib/node_modules/

# cheat.sh
curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
. ~/.bash.d/cht.sh # and add . ~/.bash.d/cht.sh to ~/.bashrc
#
# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Kitty terminal bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# symlink to path
sudo ln -s ~/.local/kitty.app/bin/kitty /usr/local/bin/
# application launcher
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# Add Icon
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# Set as default terminal
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/kitty 50

# Set keybind
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>Return']"

# Install nvim in Documents because why not
# 
# install nvim from latest stable, symlink to /usr/local/bin
NVIM_VERSION=$(git ls-remote --refs --tags git@github.com:neovim/neovim.git | cut --delimiter='/' --fields=3 | tr '-' '~' | sort --version-sort | tail --lines=1)
wget https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz -O ~/Downloads/nvim-linux64.tar.gz
mkdir -p ~/Documents/nvim-linux64
tar xf ~/Downloads/nvim-linux64.tar.gz -C ~/Documents/nvim-linux64 --strip-components=1
# symlink to /usr/local/bin/
sudo ln -s ~/Documents/nvim-linux64/bin/nvim /usr/local/bin/nvim
# Install deno for peek.nvim
curl -fsSL https://deno.land/install.sh | sh

git submodule update --init
git submodule update --recursive

# rename stuff before stow
mv ~/.tmux.conf ~/.tmux.old.conf
mv ~/.config/nvim ~/.config/nvim.old.bak
mv ~/.bashrc ~/.bashrc.old.bak
mv ~/.gitconfig ~/.gitconfig.old
# Yeah I could loop or smth, but nah
stow tmux
stow nvim
stow bash
stow scripts
stow kitty
stow git
# reload tmux
tmux source ~/.tmux.conf
