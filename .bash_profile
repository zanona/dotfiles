#!/bin/bash
HISTCONTROL=ignoreboth:erasedups #prevent repeated items in history

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
# [[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL

exports() {
  # ls -la ~/.ssh/credentials.sh | awk '{ print $9 }'
  credentials="$(find ~/.ssh/credentials.sh)"
  # shellcheck source=/Users/zanona/.ssh/credentials.sh
  source "$credentials"
    export PYTHONPATH="/usr/local/bin/python:/usr/local/share/python"
    export HEROKU_PATH="/usr/local/heroku/bin"
    # export GOPATH="$HOME/Desktop/go"
    # export NODE_PATH="$BACKUP_PATH/lib/node_modules"
    export LOCAL_NODE_PATH="./node_modules/.bin"
    export PATH="/bin:/usr/local/bin:$HEROKU_PATH:$GOPATH:$LOCAL_NODE_PATH:$PATH"
    export EDITOR="vi -w"
    export TERM="xterm-256color"
    export CLICOLOR=1
    export LSCOLORS="bxfxcxdxbxegedabagacad"
    # more at http://it.toolbox.com/blogs/lim/how-to-fix-colors-on-mac-osx-terminal-37214
}

alias vi="vim"
alias redis="redis-server"
alias tarz="tar -zcvf archive.tar.gz"
alias update="source ~/.bash_profile"
alias sync="rsync -azP --del --exclude-from .deployignore"
alias server="browser-sync start --server --startPath build"

# Sets terminal title
title() { echo -ne "\033]0;${1}\007"; }

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX );
    curl --progress-bar --upload-file "$1" https://transfer.sh/"$(basename "$1")" >> "$tmpfile";
    pbcopy < "$tmpfile";
    echo "Great Success! URL copied to clipboard ($(cat "$tmpfile"))"
    rm -f "$tmpfile";
}

debian() {
    local prevPwd
    prevPwd=$(pwd);
    cd ~/Development/vagrant/debian || exit
    vagrant "$1"
    cd "$prevPwd" || exit
}

ns() {
    dig +nocmd "$1" any +multiline +noall +answer
}

ip() {
    curl "ipinfo.io/$1"
}

getip() {
    #getting local ip address
    while read -r line
    do
      case "$line" in
       "inet "* )
            line="${line/inet /}"
            line="${line%% *}"
            if [[ ! $line =~ ^(127|172) ]] ;then
                export IP="$line"
                echo "IP: $IP"
            fi
            ;;
      esac
    done < <(ifconfig)
}
port() {
    lsof -wni tcp:"$1";
}


#add MacOSX dock separator
add_dock_spacer() {
    defaults write com.apple.dock persistent-apps -array-add '{ "tile-type" = "spacer-tile"; }'
    killall Dock
}

# Show/Hide invisible files
function hideFiles() {
    defaults write com.apple.finder AppleShowAllFiles -bool NO
    killall Finder
}
function showFiles() {
    defaults write com.apple.finder AppleShowAllFiles -bool YES
    killall Finder
}

# Set font anti-aliasing
smoothing() {
    # $1 font-smoothing level
    # 1 => light, 2 => medium, 3 => strong (usually 1 is fine)
    defaults -currentHost write -globalDomain AppleFontSmoothing -int "$1" && killall Finder
}

#show git branch on prompt
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

proml() {
  PS1="${TITLEBAR}\[\e[2m\]\$(parse_git_branch)\[\e[0m\] ⚡︎ "
  PS2='> '
  PS4='+ '
}

main() {
    exports
    # aliases
    proml
}
main
