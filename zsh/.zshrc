# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

RPROMPT="[%D{%y/%m/%f} | %D{%L:%M:%S}]"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/bin:$PATH:/opt/X11/bin:/usr/local/git/bin"
export MANPATH="/usr/local/man:$MANPATH"

fpath=(~/.zsh/completion $fpath)

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

# aliases
source ~/.zsh_aliases

# Rust
PATH=$PATH:$HOME/.cargo/bin

# Load Brex work environment if it exists
[[ -f ~/.zshrc_brex ]] && source ~/.zshrc_brex

PATH=/usr/local/opt/libxml2/bin:$PATH

autoload run-help
HELPDIR=/usr/local/share/zsh/help

# PERL_MB_OPT="--install_base \"/Users/anthonyross/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/anthonyross/perl5"; export PERL_MM_OPT;

# completion for kubectl
# source <(kubectl completion zsh)

# docker (colima)
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

export CP_HOME_DIR=/tmp/cp
alias dog=~/.asdf/installs/python/3.9.17/bin/dog
export PATH="$HOME/.local/bin:$PATH"

set -a # auto export
source ~/.env
set +a # stop auto exporting

# fix python compatability issue for brexctl
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib

zplug 'dracula/zsh', as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools

# # conda

export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

alias rust-analyzer="/opt/homebrew/Cellar/rust-analyzer/2024-07-29/bin/rust-analyzer"

export PAGER=bat

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script

export PATH="/opt/homebrew/bin/:$PATH"
