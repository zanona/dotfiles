#
# ~/.bashrc
# This runs every time a terminal is open

# set -o vi

# dont keep duplicates
export HISTCONTROL=ignoreboth:erasedups

export EDITOR=vim

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

alias ls='ls -A -v --color=auto'
alias ll='ls -l'
alias vi='vim'
alias pacman-cleanup='yay -Rsn $(yay -Qtdq)'
alias incognito='firefox --private-window'
alias reset-keys='setxkbmap -layout us'
alias docker-cleanup='\
  docker rmi $(docker images -a -q) && \
  docker rm $(docker ps -a -f status=exited -q)'
alias yay-update='yay -Syu --devel --timeupdate'
alias diff='diff -bw --color'
alias npm-update='npx npm-check -u'
alias xclip='xclip -selection clipboard'
alias ninja='if [ -z "$PS1" ]; then tput cnorm; PS1="$ "; else tput civis; PS1=; fi'

PS1='\$ '
# when in vim subshell change PS1 for clarity
if [[ $MYVIMRC ]]; then PS1='>> '; fi;

# show hostname when in SSH (this must be set on the host)
if [[ $SSH_CLIENT ]]; then PS1="$(hostname): >> "; fi;

PATH=$PATH:$HOME/bin
PATH=$PATH:node_modules/.bin
PATH=$PATH:vendor/bin

[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh --no-use
# source /usr/share/nvm/bash_completion
# source /usr/share/nvm/install-nvm-exec

# Points GPG to the correct terminal to ask for password and stuff
export GPG_TTY="$(tty)"

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
 export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# allow ssh with passphrase prompt - from gpg-agent --enable-ssh:
# Note: in case the gpg-agent receives a signature request, the user might need
# to be prompted for a passphrase, which is necessary for decrypting the stored
# key. Since the ssh-agent protocol does not contain a mechanism for telling
# the agent on which display/terminal it is running, gpg-agent's ssh-support
# will use the TTY or X display where gpg-agent has been started.
# To switch this display to the current one, the following command may be
# used: `gpg-connect-agent updatestartuptty /bye`
alias ssh='gpgconf --kill gpg-agent && gpg-connect-agent updatestartuptty /bye && ssh'
