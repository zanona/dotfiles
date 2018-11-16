#!/bin/bash
HISTCONTROL=ignoreboth:erasedups #prevent repeated items in history

exports() {
  # ls -la ~/.ssh/credentials.sh | awk '{ print $9 }'
  credentials="$(find ~/.ssh/.env)"
  # shellcheck source=/Users/zanona/.ssh/.env
  source "$credentials"

  export PYTHONPATH="/usr/local/bin/python:/usr/local/share/python"
  # export HEROKU_PATH="/usr/local/heroku/bin"
  # export GOPATH="$HOME/Desktop/go"
  # export NODE_PATH="$BACKUP_PATH/lib/node_modules"
  export LOCAL_BIN="$HOME/.bin"
  export LOCAL_NODE_PATH="./node_modules/.bin"
  export LOCAL_YARN_PATH
  export NVM_DIR="$HOME/.nvm"
  export PATH="/bin:/usr/local/bin:$LOCAL_BIN:$HEROKU_PATH:$GOPATH:$LOCAL_NODE_PATH:$LOCAL_YARN_PATH:$PATH"
  export EDITOR="vi -w"
  export TERM="xterm-256color"
  export CLICOLOR=1
  export LSCOLORS="bxfxcxdxbxegedabagacad"
  # more at http://it.toolbox.com/blogs/lim/how-to-fix-colors-on-mac-osx-terminal-37214

  # use v1 auth for webtask.io (v2 is currently incompatible with older accounts)
  # this will make `wt edit` work as expected
  export AUTH_MODE="v1"

}

alias vi="vim"
alias redis="redis-server"
alias tarz="tar -zcvf archive.tar.gz"
alias untarz="tar -xvzf"
alias update="source ~/.bash_profile"
alias sync="rsync -azP --del --exclude-from .deployignore"

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
  stat -c "%a %n" ${1:-./}*
}


# Only run on WSL
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  export BROWSER="explorer.exe"
  open() {
    explorer.exe .
  }
  browse() {
    # https://superuser.com/a/1182349/102590
    local repo=$(git remote get-url origin | cut -d ':' -f 2 | sed 's/.git//');
    local branch=$(git branch | grep \* | cut -d ' ' -f2);
    cmd.exe /c start "" https://github.com/$repo/tree/$branch;
  }
  alias pbcopy="clip.exe"
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

#nvm_load() {
#  # NVM starting too slow
#  # https://github.com/creationix/nvm/issues/782#issuecomment-387818200
#  echo 'Using nvm for the first time, setting up';
#  . $NVM_DIR/nvm.sh && . $NVM_DIR/bash_completion;
#  export PATH="$PATH:$(yarn global bin)"
#}
#
#alias nvm='unalias nvm; nvm_load; node $@'
#alias node='unalias node; unalias npm; unalias yarn; nvm_load; node $@'
#alias npm='unalias node; unalias npm; unalias yarn; nvm_load; npm $@'
#alias yarn='unalias node; unalias npm; unalias yarn; nvm_load; yarn $@'


source ~/.bashrc
main

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# open tmux on start up
if [ $SHLVL -lt 3 ]; then tmux && exit 0; fi
