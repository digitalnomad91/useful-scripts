# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

### export NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


git rev-parse 2>/dev/null;
if [ $? -eq 0 ]; then
    if [ "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) ]; then
       echo "\n"
       onefetch
       LAST_REPO=$(basename $(git rev-parse --show-toplevel))
       echo "\n"
    fi
fi


LAST_REPO=""
cd() {
    builtin cd "$@";
    git rev-parse 2>/dev/null;
    if [ $? -eq 0 ]; then
        if [ "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) ]; then
        echo "\n"
        onefetch
        LAST_REPO=$(basename $(git rev-parse --show-toplevel))
        echo "\n"
        fi
    fi
}

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

#ZSH_THEME_RANDOM_CANDIDATES=("robbyrussel", "spaceship")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
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
ENABLE_CORRECTION="true"

 
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
#plugins=(git)
plugins=(zsh-exa git node bundler docker docker-compose rake ruby python zsh-syntax-highlighting zsh-256color nvm oh-my-matrix zsh-nvm reminder common-aliases extract sudo taskwarrior yarn-autocompletions zsh-auto-nvm-use)
#zsh-bash
source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# preferred editr (I'm still too much of a loser n00b to fully commit to learning vim)
export EDITOR='nano'


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#export HISTCONTROL=ignoreboth
export HISTFILESIZE=999999999
export HISTSIZE=999999999

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#enable 256 colors for terminal
export TERM=xterm-256color

# Alias definitions.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias c='clear'
    alias ls='exa -la --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


## powerline shell stuff
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

# zsh
eval "$(navi widget zsh)"

# Wasmer
export WASMER_DIR="/home/digitalnomad91/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

PATH="/home/digitalnomad91/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/digitalnomad91/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/digitalnomad91/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/digitalnomad91/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/digitalnomad91/perl5"; export PERL_MM_OPT;
eval "
eval "
