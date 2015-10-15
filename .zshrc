# Path to your oh-my-zsh installation.
export ZSH=$HOME/dotfiles/.oh-my-zsh

# CHRUBY
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

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
plugins=(git ruby go bundler common-aliases git-extras zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# change this based on promptline
# source ~/.shell_prompt.sh

# User configuration
/usr/local/opt/go/libexec/bin
export PATH="/usr/local/bin::$PATH:opt/X11/bin:/usr/local/git/bin"
export MANPATH="/usr/local/man:$MANPATH"

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# completion
autoload -U compinit
compinit
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
alias ll="~/dotfiles/exa/target/exa -abghHliS"

export VISUAL="vim -v"
# determine vim based on OS
case "$OSTYPE" in
  darwin*)
    export EDITOR=/usr/local/bin/mvim
    mac_vim="$EDITOR -v"
    alias vi=$mac_vim
    alias vim=$mac_vim
    alias v=$mac_vim
    ;;
  linux*)
    # Assumes gtk is installed.  See script/setup for install instructions
    gtk_vim="vim -v"
    alias vi=$gtk_vim
    alias vim=$gtk_vim
    alias v=$gtk_vim
    ;;
  *)
    echo "unknown: $OSTYPE"
    ;;
esac

# display staging containers and let user input dictate logs shown
function staging_logs {
answer=""
  while [ "$answer" != "exit" ]
  do
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST=tcp://50.23.35.47:3376
    export DOCKER_CERT_PATH=~/validic/certs/
    echo "Looking up containers..."
    echo "------------------------------------------------------------------------"
    docker ps "$@"
    echo "------------------------------------------------------------------------"
    vared -p "Enter the container id to see the logs (or type exit) " -c answer
    if [[ $answer != "exit" ]]
    then
      docker logs "$answer"
      answer=""
    fi
  done
}
# docker
alias dl="docker logs"

#ruby alias
alias b="bundle"

# docker alias
alias dcb="docker-compose build"
alias dcu="docker-compose up"

# server alias
alias shipyard="ssh root@10.142.59.201"

# video -> gif converter
alias vtog="~/dotfiles/scripts/video-to-gif-osx.sh"

#Go setup
export GOPATH=$HOME/Code/go
PATH=$PATH:$GOPATH/bin

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

alias bower='noglob bower'
alias mrm='rake db:migrate && rake db:rollback && rake db:migrate'

# use ctrl + z again instead of having to use fg to get back into vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

PERL_MB_OPT="--install_base \"/Users/anthonyross/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/anthonyross/perl5"; export PERL_MM_OPT;

RUBY_CONFIGURE_OPTS="--llvm-config=/path/to/llvm-config"
