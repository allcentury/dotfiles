#!/bin/bash

set -e

c_echo() {
  tput setaf 3; echo "$1"
  # set back to normal color
  tput sgr0
}

echo "  ____ ____  ______ __ __  ___  ____  __ __ __  _____"
echo " /    |    \|      |  |  |/   \|    \|  |  |  |/ ___/"
echo "|  o  |  _  |      |  |  |     |  _  |  |  |_ (   \_ "
echo "|     |  |  |_|  |_|  _  |  O  |  |  |  ~  | \|\__  |"
echo "|  _  |  |  | |  | |  |  |     |  |  |___, |   /  \ |"
echo "|  |  |  |  | |  | |  |  |     |  |  |     |   \    |"
echo "|__|__|__|__| |__| |__|__|\___/|__|__|____/     \___|"
echo "                                                     "
echo " ___    ___  ______      _____ ____ _       ___ _____"
echo "|   \  /   \|      |    |     |    | |     /  _] ___/"
echo "|    \|     |      |    |   __||  || |    /  [(   \_ "
echo "|  D  |  O  |_|  |_|    |  |_  |  || |___|    _]__  |"
echo "|     |     | |  |      |   _] |  ||     |   [_/  \ |"
echo "|     |     | |  |      |  |   |  ||     |     \    |"
echo "|_____|\___/  |__|      |__|  |____|_____|_____|\___|"

c_echo "==> Starting dotfiles setup..."
c_echo "==> Thanks to Chris Hunt and others for making these files so great!"

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

install_for_osx(){
  c_echo "  > Updating homebrew..."
  brew update &> /dev/null

  c_echo "  > Installing reattach-to-user-namespace..."
  if command -v reattach-to-user-namespace >/dev/null 2>&1; then
    c_echo "    > (Skipping) Already installed."
  else
    brew install reattach-to-user-namespace &> /dev/null
  fi

  brew install macvim
  brew install zsh
  # install exa
  curl -sSf https://static.rust-lang.org/rustup.sh | sh
  cargo install --git https://github.com/ogham/exa
  brew install ruby-install
  brew install chruby
  brew install tmux

  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  symlink_files
}

symlink_files() {
  c_echo "Symlinking dot files from organized folders..."

  # ZSH files
  c_echo "Linking ZSH files..."
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
  ln -sf "$DOTFILES_DIR/zsh/.zsh_aliases" ~/.zsh_aliases

  # Neovim files
  c_echo "Linking Neovim files..."
  mkdir -p ~/.config/nvim
  ln -sf "$DOTFILES_DIR/vim/init.lua" ~/.config/nvim/init.lua
  ln -sf "$DOTFILES_DIR/vim/lua" ~/.config/nvim/lua

  # Tmux files
  c_echo "Linking Tmux files..."
  ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

  # Git files
  c_echo "Linking Git files..."
  ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
  ln -sf "$DOTFILES_DIR/git/.gitmessage" ~/.gitmessage

  # Alacritty files
  c_echo "Linking Alacritty files..."
  mkdir -p ~/.config/alacritty
  ln -sf "$DOTFILES_DIR/alacritty/.alacritty.toml" ~/.config/alacritty/alacritty.toml
}

install_for_linux(){
  c_echo "Linux detected, updating packages..."
  sudo apt-get -y update        # Fetches the list of available updates
  sudo apt-get -y upgrade       # Strictly upgrades the current packages
  sudo apt-get -y dist-upgrade  # Installs updates (new ones)
  c_echo "Installing Git..."
  sudo apt-get -y install git-core
  c_echo "Removing system vim and replacing it with gtk"
  sudo apt-get -y purge vim gvim vim-gtk
  sudo apt-get -y install vim-gtk
  c_echo "Installing tmux..."
  sudo apt-get -y install tmux
  c_echo "Installing silver searcher"
  sudo apt-get -y install silversearcher-ag
  c_echo "Installing zsh"
  sudo apt-get -y install zsh
  c_echo "Setting zsh as default shell"
  chsh -s /bin/zsh
  c_echo "Installing oh-my-zsh"
  sudo apt-get -y install wget
  ( exec wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - )

  symlink_files
}

case "$OSTYPE" in
  darwin*)  install_for_osx ;;
  linux*)   install_for_linux ;;
  *)        c_echo "unknown: $OSTYPE" ;;
esac

# move into dotfiles and pull down vim, oh-my-zsh, exa etc
c_echo "  > Updating all git submodules..."
git submodule init
git submodule update
git config alias.supdate 'submodule update --remote --merge'

c_echo "Reloading shell.."
exec zsh
c_echo "==> Done with setup."