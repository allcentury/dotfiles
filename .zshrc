# Path to your oh-my-zsh installation.
export ZSH=$HOME/dotfiles/.oh-my-zsh

# CHRUBY
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

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
plugins=(git ruby go bundler common-aliases git-extras zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# change this based on promptline
# source ~/.shell_prompt.sh

# User configuration
export PATH="/usr/local/bin::$PATH:opt/X11/bin:/usr/local/git/bin"
export MANPATH="/usr/local/man:$MANPATH"

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
source ~/.zsh_aliases

# Go setup
export GOPATH=$HOME/Code/go
PATH=$PATH:$GOPATH/bin

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help


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

# add Java export for RDS cli
export JAVA_HOME="$(/usr/libexec/java_home)"
export AWS_RDS_HOME="/Users/anthonyross/projects/rds-cli/RDSCli-1.19.004"
export PATH=$PATH:$AWS_RDS_HOME/bin
export AWS_CREDENTIAL_FILE="~/projects/rds-cli/RDSCli-1.19.004/credential-file-path.template"
export FCEDIT=$mac_vim


# Docker
export DOCKER_HOST=tcp://192.168.99.100:2376
export DOCKER_IP=192.168.99.100
export DOCKER_MACHINE_NAME=default
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=/Users/anthonyross/.docker/machine/machines/default
alias docker-create='docker-machine create -d virtualbox default'
alias docker-start='docker-machine start default'
