# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.

# Fix for long lines not being correctly rendered in bash
# https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=14800

# Normal Colors
BLACK="\001\e[0;30m\002"        # Black
RED="\001\e[0;31m\002"          # Red
GREEN="\001\e[0;32m\002"        # Green
YELLOW="\001\e[0;33m\002"       # Yellow
BLUE="\001\e[0;34m\002"         # Blue
PURPLE="\001\e[0;35m\002"       # Purple
CYAN="\001\e[0;36m\002"         # Cyan
WHITE="\001\e[0;37m\002"        # White

# Bold
BBLACK="\001\e[1;30m\002"       # Black
BRED="\001\e[1;31m\002"         # Red
BGREEN="\001\e[1;32m\002"       # Green
BYELLOW="\001\e[1;33m\002"      # Yellow
BBLUE="\001\e[1;34m\002"        # Blue
BPURPLE="\001\e[1;35m\002"      # Purple
BCYAN="\001\e[1;36m\002"        # Cyan
BWHITE="\001\e[1;37m\002"       # White

# Background
ON_BLACK="\001\e[40m\002"       # Black
ON_RED="\001\e[41m\002"         # Red
ON_GREEN="\001\e[42m\002"       # Green
ON_YELLOW="\001\e[43m\002"      # Yellow
ON_BLUE="\001\e[44m\002"        # Blue
ON_PURPLE="\001\e[45m\002"      # Purple
ON_CYAN="\001\e[46m\002"        # Cyan
ON_WHITE="\001\e[47m\002"       # White

# Other
NC="\001\e[0m\002"              # Color Reset
SMILEY=":)"                     # :)
FROWNY=":("                     # :(
FANCYX="\342\234\227"           # [✘] / \342\234\227
CHECKMARK="\342\234\223"        # [✔] / \342\234\223
ALERT=${BWHITE}${ON_RED}        # Bold White on red background

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# don't store the following commands in history
HISTIGNORE="&:bg:fg:h"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# add date/time information
HISTTIMEFORMAT="$(echo -e ${BCYAN})[%F %T]$(echo -e ${NC}) "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-88color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
	    color_prompt=yes
    else
	    color_prompt=
    fi
fi

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# include functions from a separate file
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions;
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ "$color_prompt" = yes ]; then
    #PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PROMPT_COMMAND=__prompt_command
else
    PS1='\u@\h:\w\$ '
fi
#unset color_prompt force_color_prompt

# http://www.skorks.com/2009/09/bash-shortcuts-for-maximum-productivity/#comment-587673785
/bin/stty -ixon

# user locale
#export LANG="en_GB.utf8"
export LC_CTYPE="cs_CZ.utf8"
export LC_NUMERIC="cs_CZ.utf8"
export LC_TIME="cs_CZ.utf8"
export LC_COLLATE="cs_CZ.utf8"
export LC_MONETARY="cs_CZ.utf8"
export LC_MESSAGES="en_US.utf8"
export LC_PAPER="cs_CZ.utf8"
export LC_NAME="cs_CZ.utf8"
export LC_ADDRESS="cs_CZ.utf8"
export LC_TELEPHONE="cs_CZ.utf8"
export LC_MEASUREMENT="cs_CZ.utf8"
#export LC_IDENTIFICATION="en_GB.utf8"

# editor
export EDITOR="vim"

# fix for > Dropbox 2.7.x indicator problems
# https://bugs.launchpad.net/elementaryos/+bug/1357938/comments/10
export DROPBOX_USE_LIBAPPINDICATOR=1

# keychain
if [ -f ~/.keychain/${HOSTNAME}-sh ]; then
    source ~/.keychain/${HOSTNAME}-sh
fi

# logging terminal session
#if [ -z "$UNDER_SCRIPT" ]; then
#    logdir=$HOME/terminal-logs
#    if [ ! -d $logdir ]; then
#        mkdir $logdir
#    fi
#    gzip -q $logdir/*.log
#    logfile=$logdir/$(date '+%Y-%m-%d_%T').$$.log
#    export UNDER_SCRIPT=$logfile
#    script -f -q $logfile
#    exit
#fi
