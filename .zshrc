# Path to your oh-my-zsh installation.
export ZSH=$HOME/dotfiles/.oh-my-zsh

bindkey '^r' history-incremental-search-backward

# CHRUBY
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="avit"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ruby go bundler common-aliases git-extras zsh-syntax-highlighting docker)
source $ZSH/oh-my-zsh.sh

# change this based on promptline
# source ~/.shell_prompt.sh

# User configuration
export PATH="/usr/local/bin::$PATH:opt/X11/bin:/usr/local/git/bin"
export MANPATH="/usr/local/man:$MANPATH"

fpath=(~/dotfiles/.zsh/completion $fpath)
# completion
autoload -Uz compinit && compinit -i
#
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# aliases
source ~/dotfiles/.zsh_aliases

# Go setup
export GOPATH=$HOME/Code/go
PATH=$PATH:$GOPATH/bin

# Rust
PATH=$PATH:$HOME/.cargo/bin

autoload run-help
HELPDIR=/usr/local/share/zsh/help


PERL_MB_OPT="--install_base \"/Users/anthonyross/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/anthonyross/perl5"; export PERL_MM_OPT;

RUBY_CONFIGURE_OPTS="--llvm-config=/path/to/llvm-config"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
