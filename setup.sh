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

backup_existing_file() {
  local file_path="$1"
  if [[ -f "$file_path" || -L "$file_path" ]]; then
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${file_path}_backup_${timestamp}"
    c_echo "Backing up existing $file_path to $backup_path"
    mv "$file_path" "$backup_path"
  fi
}

setup_environment() {
  c_echo "Setting up environment-specific configurations..."

  # Prompt for environment type
  echo "Which environment are you setting up?"
  echo "1) Personal"
  echo "2) Brex (work)"
  read -p "Enter choice [1-2]: " choice

  case $choice in
    1)
      c_echo "Setting up personal environment..."
      # For personal, we don't need to add anything extra
      ;;
    2)
      c_echo "Setting up Brex work environment..."

      # Add brex-specific sourcing to .zshrc
      if ! grep -q "source ~/.zshrc_brex" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Brex work environment" >> ~/.zshrc
        echo "source ~/.zshrc_brex" >> ~/.zshrc
      fi

      # Copy brex-specific files
      if [[ -f "$DOTFILES_DIR/zsh/.zshrc_brex" ]]; then
        c_echo "Copying Brex ZSH overrides..."
        cp "$DOTFILES_DIR/zsh/.zshrc_brex" ~/.zshrc_brex
      fi

      if [[ -f "$DOTFILES_DIR/git/.gitconfig_brex" ]]; then
        c_echo "Copying Brex Git overrides..."
        cp "$DOTFILES_DIR/git/.gitconfig_brex" ~/.gitconfig_brex
      fi
      ;;
    *)
      c_echo "Invalid choice, defaulting to personal..."
      ;;
  esac
}

symlink_files() {
  c_echo "Symlinking dot files from organized folders..."

  # ZSH files
  c_echo "Linking ZSH files..."
  backup_existing_file ~/.zshrc
  backup_existing_file ~/.zsh_aliases
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
  ln -sf "$DOTFILES_DIR/zsh/.zsh_aliases" ~/.zsh_aliases

  # Neovim files
  c_echo "Linking Neovim files..."
  mkdir -p ~/.config/nvim
  backup_existing_file ~/.config/nvim/init.lua
  backup_existing_file ~/.config/nvim/lua
  ln -sf "$DOTFILES_DIR/vim/init.lua" ~/.config/nvim/init.lua
  ln -sf "$DOTFILES_DIR/vim/lua" ~/.config/nvim/lua

  # Tmux files
  c_echo "Linking Tmux files..."
  backup_existing_file ~/.tmux.conf
  ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

  # Git files
  c_echo "Linking Git files..."
  backup_existing_file ~/.gitconfig
  backup_existing_file ~/.gitmessage
  ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
  ln -sf "$DOTFILES_DIR/git/.gitmessage" ~/.gitmessage

  # Alacritty files
  c_echo "Linking Alacritty files..."
  mkdir -p ~/.config/alacritty
  backup_existing_file ~/.config/alacritty/alacritty.toml
  ln -sf "$DOTFILES_DIR/alacritty/.alacritty.toml" ~/.config/alacritty/alacritty.toml

  # Setup environment-specific configurations
  setup_environment
}

# Check for --symlinks-only flag
if [[ "$1" == "--symlinks-only" ]]; then
  c_echo "Running symlinks-only mode..."
  symlink_files
  exit 0
fi

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
  c_echo "Installing oh-my-zsh"
  if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    c_echo "oh-my-zsh is already installed"
  fi

  # install zplug
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

  symlink_files
}

setup_environment() {
  c_echo "Setting up environment-specific configurations..."

  # Prompt for environment type
  echo "Which environment are you setting up?"
  echo "1) Personal"
  echo "2) Brex (work)"
  read -p "Enter choice [1-2]: " choice

  case $choice in
    1)
      c_echo "Setting up personal environment..."
      # For personal, we don't need to add anything extra
      ;;
    2)
      c_echo "Setting up Brex work environment..."

      # Add brex-specific sourcing to .zshrc
      if ! grep -q "source ~/.zshrc_brex" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Brex work environment" >> ~/.zshrc
        echo "source ~/.zshrc_brex" >> ~/.zshrc
      fi

      # Copy brex-specific files
      if [[ -f "$DOTFILES_DIR/zsh/.zshrc_brex" ]]; then
        c_echo "Copying Brex ZSH overrides..."
        cp "$DOTFILES_DIR/zsh/.zshrc_brex" ~/.zshrc_brex
      fi

      if [[ -f "$DOTFILES_DIR/git/.gitconfig_brex" ]]; then
        c_echo "Copying Brex Git overrides..."
        cp "$DOTFILES_DIR/git/.gitconfig_brex" ~/.gitconfig_brex
      fi
      ;;
    *)
      c_echo "Invalid choice, defaulting to personal..."
      ;;
  esac
}

backup_existing_file() {
  local file_path="$1"
  if [[ -f "$file_path" || -L "$file_path" ]]; then
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${file_path}_backup_${timestamp}"
    c_echo "Backing up existing $file_path to $backup_path"
    mv "$file_path" "$backup_path"
  fi
}

symlink_files() {
  c_echo "Symlinking dot files from organized folders..."

  # ZSH files
  c_echo "Linking ZSH files..."
  backup_existing_file ~/.zshrc
  backup_existing_file ~/.zsh_aliases
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
  ln -sf "$DOTFILES_DIR/zsh/.zsh_aliases" ~/.zsh_aliases

  # Neovim files
  c_echo "Linking Neovim files..."
  mkdir -p ~/.config/nvim
  backup_existing_file ~/.config/nvim/init.lua
  backup_existing_file ~/.config/nvim/lua
  ln -sf "$DOTFILES_DIR/vim/init.lua" ~/.config/nvim/init.lua
  ln -sf "$DOTFILES_DIR/vim/lua" ~/.config/nvim/lua

  # Tmux files
  c_echo "Linking Tmux files..."
  backup_existing_file ~/.tmux.conf
  ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

  # Git files
  c_echo "Linking Git files..."
  backup_existing_file ~/.gitconfig
  backup_existing_file ~/.gitmessage
  ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
  ln -sf "$DOTFILES_DIR/git/.gitmessage" ~/.gitmessage

  # Alacritty files
  c_echo "Linking Alacritty files..."
  mkdir -p ~/.config/alacritty
  backup_existing_file ~/.config/alacritty/alacritty.toml
  ln -sf "$DOTFILES_DIR/alacritty/.alacritty.toml" ~/.config/alacritty/alacritty.toml

  # Setup environment-specific configurations
  setup_environment
}

install_for_linux(){
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