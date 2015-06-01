# vim: set filetype=sh:

# naive check for busybox machines
BBOX=$(ls --help 2>&1 | grep BusyBox | wc -l)
if [ "${BBOX}" == 0 ]; then
    ARGLSDIR="--group-directories-first"
    ARGLSTIM="--time-style=long-iso"
    ARGCPUPD="-u"
    ARGDFFSI="-T -x fuse.gvfs-fuse-daemon"
else
    ARGLSDIR=""
    ARGLSTIM=""
fi

# enable color support of ls and also add handy aliases
if [ $(which dircolors) ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto ${ARGLSTIM}"
    alias dir='dir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands. Use like so:
if [ $(which notify-send) ]; then
    #sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# ls
alias l="ls -lh ${ARGLSDIR}"    # long listing format and si units
alias ll="ls -lah ${ARGLSDIR}"  # long listing format including config files
alias la="ls -a ${ARGLSDIR}"    # list everything
alias l.="ls -d .* ${ARGLSDIR}" # list just configuration related files/folders
alias lr="ls -R ${ARGLSDIR}"    # recursive listing
alias lX='ls -lX'               # sort by extension
alias lS='ls -lS'               # sort by size
alias lt='ls -lt'               # sort by mod time, reverse order

# df and du
alias du='du -h'                # human readable units
alias df="df -kh ${ARGDFFSI}"   # human readable units

# rm, cp and mv
alias rm='rm -i'
alias mv='mv -i'
alias cp="cp -a ${ARGCPUPD}"
alias cr='cp -R'

# history
alias h='history | tail -15'

# cd
alias ..='cd ..'        # up
alias ...='cd ../..'
alias .,='cd $OLDPWD'

# vim related
# for RHEL
if [ $(which vimx) ]; then
    alias vim='/usr/bin/vimx'
fi
alias :q='exit'
# alias :m='pushd'      # store a path
# alias :d='popd'       # pop a path

# yum related
if [ $(which yum) ]; then
    alias yumi='sudo yum install'
    alias yumr='sudo yum remove'
    alias yums='yum search'
    alias yumS='yum info'
    alias yumd='yum deplist'
    alias yumq='yum provides'
    alias yumf='repoquery -l --installed'
    alias yumh='sudo yum history'
fi

# apt related
if [ $(which apt-get 2> /dev/null) ]; then
    alias apti='sudo apt-get install'
    alias aptr='sudo apt-get remove'
    alias aptR='sudo apt-get purge'
    alias apta='sudo apt-get autoremove'
    alias aptp='sudo apt-get purge'
    alias aptu='sudo apt-get update'
    alias aptU='sudo apt-get upgrade'
    alias apts='apt-cache search'
    alias aptS='apt-cache show'
    alias aptf='dpkg -L'
    alias aptq='dpkg-query -S'
fi

# AIX command completion help
# https://www.ibm.com/developerworks/community/blogs/brian/entry/finding_command_names_on_aix_using_the_korn_shell?lang=en
#alias lscmd='for dir in `echo $PATH | tr ":" " "`; do for file in `ls -1 "$dir"`; do [ -x "$dir/$file" ] && echo $file; done; done | sort | uniq'

# 't' - todo list manager
# https://bitbucket.org/sjl/t/src
if [ -e ~/bin/t/t.py ]; then
    alias t='python ~/bin/t/t.py --task-dir ~/tasks --list tasks'
    #export PS1="[$(t | wc -l | sed -e's/ *//')] $PS1"
fi

# mutt related
# fixed the problem with mutt not redrawing screen
# http://objectmix.com/mutt/202183-mutt-refresh-update-screen.html
if [ $(which mutt) ]; then
    alias m="TERM=xterm-color mutt"
fi

