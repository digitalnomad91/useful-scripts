# ~/.bashrc: executed by bash when launching new interactive shell

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

export TERM=xterm-256color
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

HISTCONTROL=ignoreboth
HISTFILESIZE=999999999
HISTSIZE=999999999
# custom / colorful shell prompt
PS1='${debian_chroot:+($debian_chroot)}\[\e[1;31m\]\u\[\e[1;33m\]@\[\e[1;36m\]\h \[\e[1;33m\]\w \[\e[1;35m\]\$ \[\e[0m\]'

# alias for finding which process a particular port is running from
alias ports='sudo lsof -i -P -n | grep LISTEN'

# catch stdin, pipe it to stdout and save to a file
function catch () { 
	cat - | tee /tmp/catch.out 
}
# print whatever output was saved to a file
function res () { 
	cat /tmp/catch.out 
}

#node.js quirk with older versions
#export NODE_OPTIONS=--openssl-legacy-provider

#node virtual manager stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"


# powerline-shell prompt (overrides the custom colorful one set in PS1 above)
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
