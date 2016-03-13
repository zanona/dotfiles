HISTCONTROL=erasedups

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
# [[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL

exports() {
    source `ls -la ~/.ssh/credentials.sh | awk '{ print $9 }'`
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
alias tarz="tar -zcvf archive.tar.gz"
alias update="source ~/.bash_profile"
alias sync="rsync -azP --del --exclude-from .deployignore"
alias server="browser-sync start --server --startPath build"

sts() { eval "$(sts-switch)"; }

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX ); curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    cat "$tmpfile" | pbcopy;
    rm -f "$tmpfile";
}

debian() {
    local prevPwd=$(pwd);
    cd ~/Development/vagrant/debian
    vagrant "$1"
    cd "$prevPwd"
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
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

proml() {
  PS1="${TITLEBAR}\$(parse_git_branch)\\\$ "
  PS2='> '
  PS4='+ '
}

main() {
    exports
    # aliases
    proml
}
main

s3create() {
    local answer
    local locs=(us-east-1 us-west-2 us-west-1 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1)
    local location
    local domain=$1

    read -p "Select your new bucket location:

    1. Northern Virginia (US)                  us-east-1
    2. US West (Oregon) Region                 us-west-2
    3. US West (Northern California) Region    us-west-1
    4. EU (Ireland) Region                     eu-west-1
    5. Asia Pacific (Singapore) Region         ap-southeast-1
    6. Asia Pacific (Sydney) Region            ap-southeast-2
    7. Asia Pacific (Tokyo) Region             ap-northeast-1
    8. South America (Sao Paulo) Region        sa-east-1
    " answer

    location=${locs[(($answer - 1))]}

    cat > /tmp/s3policy.xml <<_EOF_
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Princial": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${domain}/*"
        }
    ]
}
_EOF_

    s3cmd mb "s3://$domain" --bucket-location $location
    s3cmd setpolicy /tmp/s3policy.xml "s3://$domain"
    s3cmd ws-create "s3://$domain"
    echo "Set your host CNAME to s3-website-${location}.amazonaws.com"
    # --ws-error=404.html
    # s3cmd info s3://$domain
}

s3push-old() {
    local dpath=$(basename "$PWD")
    local fpath=(`echo`)
    local i=0
    local b

    function join { local IFS="$1"; shift; echo "$*"; }

    IFS='.' read -ra PT <<< "$dpath"

    for (( idx=${#PT[@]}-1 ; idx>=0 ; idx-- )) ; do
        fpath[$i]="${PT[idx]}"
        i=$((i+1))
    done

    if [[ $1 ]]; then
        b=$1
    else
        b=$(join . "${fpath[@]}")
    fi

    s3cmd sync ./ "s3://$b" --delete-removed --exclude ".DS_Store" --exclude ".htaccess" --exclude ".s3ignore" --exclude ".git/*" --exclude "src/*" "$2"
}
s3push() {
    s3cmd sync "$1" "s3://$2" --delete-removed
    #--add-header='Cache-Control:max-age=31536000, public' --add-header='Content-Encoding: gzip'
}

coresync() {
    # fsmonitor
    SERVER=$1
    NAME=$2
    rsync -azP --del --exclude '.git' --exclude 'node_modules' ./ "$SERVER:$NAME" > /dev/null 2>&1
    # echo "./$NAME/app.service"
    ssh "$SERVER fleetctl destroy $NAME" > /dev/null
    echo 'Restarting Application…'
    sleep 4
    ssh "$SERVER fleetctl load $NAME/$NAME.service" > /dev/null
    ssh "$SERVER fleetctl start $NAME" > /dev/null
    echo Ready!
    # ssh vagrant docker kill $NAME
    # ssh vagrant docker rm $NAME
    # ssh vagrant docker build --tag app ./$NAME
    # ssh vagrant docker run -d --name $NAME $NAME
    # ssh vagrant docker inspect $NAME | grep IPAddress | awk '{print $2}'
}
