#!/usr/bin/env bash

#sudo apt update
#
sudo apt install -y git
sudo apt install -y stow # needed for dotfile management
sudo apt install -y tmux
sudo apt install -y ripgrep
sudo apt install -y wget tar curl
sudo apt install -y fzf feh picom i3lock xss-lock blueman
sudo apt install -y lxappearance xbacklight
sudo apt install -y flameshot
sudo apt install -y autorandr arandr
sudo apt install -y playerctl
# clipboard stuff for x11 and wayland
sudo apt install xclip wl-clipboard

# From fixit github
# Install fixit if not exists
if ! dpkg -s fixit &>/dev/null; then
    echo "Installing fixit"
    echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://eugene-babichenko.github.io/fixit/ppa ./" | sudo tee /etc/apt/sources.list.d/fixit.list >/dev/null
    sudo apt update
    sudo apt install -y fixit
else
    echo "fixit is already installed"
fi

# install node and npm if not exists
if ! command -v node &>/dev/null; then
    echo "Installing nodejs"
    curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
    sudo -E bash nodesource_setup.sh
    rm nodesource_setup.sh
    sudo apt install -y nodejs
    # Chown npm and node modules
    sudo chown -R $USER ~/.npm
    sudo chown -R $USER /usr/lib/node_modules/
else
    echo "nodejs already installed"
fi

# cheat.sh
if [ ! -f /usr/local/bin/cht.sh ]; then
    echo "Installing cht.sh"
    curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
    . ~/.bash.d/cht.sh # and add . ~/.bash.d/cht.sh to ~/.bashrc
else
    echo "cht.sh already installed"
fi

# install rustup
if ! command -v rustup &>/dev/null; then
    echo "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "rustup already installed"
fi

if [ ! -f ~/.local/kitty.app/bin/kitty ]; then
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
else
    echo "Kitty is already installed"
fi

# Only works on gnome, whatever
# Set keybind
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>Return']"
fi

# Install nvim in Documents because why not
if [ ! ~/Documents/nvim-linux64/bin/nvim ]; then
    echo "Installing nvim"
    # install nvim from latest stable, symlink to /usr/local/bin
    NVIM_VERSION=$(git ls-remote --refs --tags git@github.com:neovim/neovim.git | cut --delimiter='/' --fields=3 | tr '-' '~' | sort --version-sort | tail --lines=1)
    wget https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz -O ~/Downloads/nvim-linux64.tar.gz
    mkdir -p ~/Documents/nvim-linux64
    tar xf ~/Downloads/nvim-linux64.tar.gz -C ~/Documents/nvim-linux64 --strip-components=1
    # symlink to /usr/local/bin/
    sudo ln -s ~/Documents/nvim-linux64/bin/nvim /usr/local/bin/nvim
else
    echo "nvim already installed"
fi

if ! command -v deno &>/dev/null; then
    echo "installing deno"
    # Install deno for peek.nvim
    curl -fsSL https://deno.land/install.sh | sh
else
    echo "deno already installed"
fi

git submodule update --init --recursive

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
backup_if_not_symlink ~/.bashrc
backup_if_not_symlink ~/.gitconfig
backup_if_not_symlink ~/.bash.d

# Stow all
for dir in tmux nvim bash scripts kitty git picom i3; do
    stow "$dir"
done
# reload tmux
tmux source ~/.tmux.conf || true
