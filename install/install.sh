#!/bin/bash
#
# Full machine bootstrap: install packages, oh-my-zsh, zplug, fetch submodules,
# then symlink all dotfiles into place.
#
# For just the symlinks (no package installs), run install/symlink.sh directly.

set -e

c_echo() {
  tput setaf 3; echo "$1"
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

c_echo "==> Starting dotfiles install..."
c_echo "==> Thanks to Chris Hunt and others for making these files so great!"

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$INSTALL_DIR/.." && pwd)"
cd "$DOTFILES_DIR"

install_for_osx() {
  c_echo "  > Updating homebrew..."
  brew update &> /dev/null

  c_echo "  > Installing reattach-to-user-namespace..."
  if command -v reattach-to-user-namespace >/dev/null 2>&1; then
    c_echo "    > (Skipping) Already installed."
  else
    brew install reattach-to-user-namespace &> /dev/null
  fi

  brew install neovim
  brew install bash
  brew install zsh
  brew install tmux
  brew install zplug

  c_echo "Installing oh-my-zsh"
  if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    c_echo "oh-my-zsh is already installed"
  fi

  c_echo "Installing zplug"
  export ZPLUG_HOME=~/.zplug
  if [[ ! -d "$ZPLUG_HOME" ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
  else
    c_echo "zplug is already installed"
  fi

  # Add GitHub to known_hosts to avoid SSH prompts
  mkdir -p ~/.ssh
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
}

install_for_linux() {
  c_echo "Linux detected, updating packages..."
  sudo apt-get -y update        # Fetches the list of available updates
  sudo apt-get -y upgrade       # Strictly upgrades the current packages

  c_echo "Installing essential packages..."
  sudo apt-get -y install \
    git \
    curl \
    wget \
    zsh \
    tmux \
    neovim \
    build-essential \
    ripgrep \
    locales

  # Set up proper locale to avoid Unicode issues
  sudo locale-gen en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  c_echo "Setting zsh as default shell"
  if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s /usr/bin/zsh
  else
    c_echo "zsh is already the default shell"
  fi

  c_echo "Installing oh-my-zsh"
  if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
  else
    c_echo "oh-my-zsh is already installed"
  fi

  c_echo "Installing zplug"
  export ZPLUG_HOME=~/.zplug
  if [[ ! -d "$ZPLUG_HOME" ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
  else
    c_echo "zplug is already installed"
  fi

  # Add GitHub to known_hosts to avoid SSH prompts
  mkdir -p ~/.ssh
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
}

case "$OSTYPE" in
  darwin*)  install_for_osx ;;
  linux*)   install_for_linux ;;
  *)        c_echo "unknown: $OSTYPE" ;;
esac

# Pull down vim plugins, oh-my-zsh, etc.
c_echo "  > Updating all git submodules..."
git submodule init
git submodule update
git config alias.supdate 'submodule update --remote --merge'

# Symlink all the dotfiles into place.
"$INSTALL_DIR/symlink.sh"

c_echo "==> Done with install. Reloading shell..."
exec zsh
