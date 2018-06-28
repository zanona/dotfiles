#!/bin/bash
HISTCONTROL=ignoreboth:erasedups #prevent repeated items in history

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
# [[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL

exports() {
  # ls -la ~/.ssh/credentials.sh | awk '{ print $9 }'
  credentials="$(find ~/.ssh/.env)"
  # shellcheck source=/Users/zanona/.ssh/.env
  source "$credentials"
    export PYTHONPATH="/usr/local/bin/python:/usr/local/share/python"
    export HEROKU_PATH="/usr/local/heroku/bin"
    # export GOPATH="$HOME/Desktop/go"
    # export NODE_PATH="$BACKUP_PATH/lib/node_modules"
    export LOCAL_BIN="$HOME/.bin"
    export LOCAL_NODE_PATH="./node_modules/.bin"
    export LOCAL_YARN_PATH
    LOCAL_YARN_PATH=$(yarn global bin)
    export PATH="/bin:/usr/local/bin:$LOCAL_BIN:$HEROKU_PATH:$GOPATH:$LOCAL_NODE_PATH:$LOCAL_YARN_PATH:$PATH"
    export EDITOR="vi -w"
    export TERM="xterm-256color"
    export CLICOLOR=1
    export LSCOLORS="bxfxcxdxbxegedabagacad"
    # more at http://it.toolbox.com/blogs/lim/how-to-fix-colors-on-mac-osx-terminal-37214

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

iplocal() {
    ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}
port() {
    lsof -wni tcp:"$1";
}
search() {
  grep -r --exclude-dir=node_modules --exclude=yarn.lock --exclude=*.swp --exclude=build/* "$1" ${2:-*}
}
setenv() {
  export $(cat $1 | xargs)
}
perms() {
  stat -c "%a %n" *
}


# Only run on WSL
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  open() {
    explorer.exe .
  }
  browse() {
    # https://superuser.com/a/1182349/102590
    cmd.exe /c start "" https://github.com/$(git remote get-url origin | cut -d ':' -f 2)
  }
else
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
fi

#show git branch on prompt
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1:/'
}

git_completion() {
  credentials="$(find ~/.git-completion.sh)"
  # shellcheck source=/Users/zanona/.git-completion.sh
  source "$credentials"
}

proml() {
  #about prompts goo.gl/6tMCDn
  #for getting utf-8 hex user `echo ⚡︎ | hexdump -C`
  #about special chars on prompt goo.gl/eVAypu
  #ICON='⚡︎'
  ICON='$'
  #ICON=$'\\[\xE2\\]\\[\x9A\\]\\[\xA1\\]\\[\xEF\\]\\[\xB8\\]\\[\x8E\\]'
  if [[ $MYVIMRC ]]; then ICON='>>'; fi;
  BRANCH="\$(parse_git_branch)"
  PS1="  ${ICON} ${BRANCH} "
  PS2='    -> '
}

main() {
    exports
    # aliases
    proml
    git_completion
}
main
