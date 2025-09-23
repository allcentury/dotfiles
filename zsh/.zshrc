# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

bindkey '^r' history-incremental-search-backward

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
plugins=(git ruby go bundler common-aliases git-extras)
source $ZSH/oh-my-zsh.sh

# change this based on promptline
# source ~/.shell_prompt.sh

# User configuration
export PATH="/usr/local/bin::$PATH:opt/X11/bin:/usr/local/git/bin"
export MANPATH="/usr/local/man:$MANPATH"

fpath=(~/.zsh/completion $fpath)
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
source ~/.zsh_aliases

# Rust
PATH=$PATH:$HOME/.cargo/bin

# Load Brex work environment if it exists
[[ -f ~/.zshrc_brex ]] && source ~/.zshrc_brex

#GO
PATH=$PATH:$(go env GOPATH)/bin
GOPATH=$(go env GOPATH)


PATH=$PATH:$HOME/Library/Android/sdk
PATH=$PATH:$HOME/Library/Android/sdk/platform-tools
PATH=/usr/local/opt/libxml2/bin:$PATH

autoload run-help
HELPDIR=/usr/local/share/zsh/help

# PERL_MB_OPT="--install_base \"/Users/anthonyross/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/anthonyross/perl5"; export PERL_MM_OPT;

RUBY_CONFIGURE_OPTS="--llvm-config=/path/to/llvm-config"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# completion for kubectl
# source <(kubectl completion zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/anthonyross/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/anthonyross/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/anthonyross/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/anthonyross/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/anthonyross/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/anthonyross/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/anthonyross/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/anthonyross/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

eval "$(pyenv init -)"

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home

export EDITOR=vim
