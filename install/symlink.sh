#!/bin/bash
#
# Symlink all dotfiles from this repo into their expected locations.
# Safe to run standalone and repeatedly — existing real files are backed up,
# and links that already point at the right place are left untouched.

set -e

c_echo() {
  tput setaf 3; echo "$1"
  tput sgr0
}

# Repo root is the parent of this script's directory (install/).
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

backup_existing_file() {
  local file_path="$1"
  if [[ -e "$file_path" || -L "$file_path" ]]; then
    local backup_path="${file_path}_backup_$(date +%Y%m%d_%H%M%S)"
    c_echo "Backing up existing $file_path -> $backup_path"
    mv "$file_path" "$backup_path"
  fi
}

# link <source-relative-to-repo> <absolute-destination>
link() {
  local src="$DOTFILES_DIR/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    c_echo "(skip) $dest already linked"
    return
  fi
  backup_existing_file "$dest"
  ln -sf "$src" "$dest"
  c_echo "Linked $dest -> $src"
}

setup_environment() {
  c_echo "Setting up environment-specific configurations..."

  echo "Which environment are you setting up?"
  echo "1) Personal"
  echo "2) Brex (work)"
  read -p "Enter choice [1-2]: " choice

  case $choice in
    2)
      c_echo "Setting up Brex work environment..."

      if ! grep -q "source ~/.zshrc_brex" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Brex work environment" >> ~/.zshrc
        echo "source ~/.zshrc_brex" >> ~/.zshrc
      fi

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
      c_echo "Setting up personal environment (nothing extra to do)..."
      ;;
  esac
}

c_echo "==> Symlinking dotfiles from $DOTFILES_DIR ..."

link "zsh/.zshrc"                "$HOME/.zshrc"
link "zsh/.zsh_aliases"          "$HOME/.zsh_aliases"
link "vim/init.lua"              "$HOME/.config/nvim/init.lua"
link "vim/lua"                   "$HOME/.config/nvim/lua"
link "tmux/.tmux.conf"           "$HOME/.tmux.conf"
link "git/.gitconfig"            "$HOME/.gitconfig"
link "git/.gitmessage"           "$HOME/.gitmessage"
link "alacritty/.alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

setup_environment

c_echo "==> Symlinks done."
