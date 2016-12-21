# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth
# Don't store the following commands in history
export HISTIGNORE="&:bg:fg:h"
# Append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000
# add date/time information
export HISTTIMEFORMAT="[%F %T]  "
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar



# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi


# Define editor
export EDITOR="vim"


# Fix unnecesary glibc related stat() syscalls
# http://stackoverflow.com/questions/4554271/how-to-avoid-excessive-stat-etc-localtime-calls-in-strftime-on-linux
#TZ=":/etc/localtime"; export TZ
TZ="Europe/Prague"; export TZ


# Include aliases for a separate file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# And local ones, too
if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi

# Include functions from a separate file
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions;
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# Color Reset definition
NC="\001\e[0m\002"

# Set terminal based on number of colors detected
if [ "$(tput colors)c" == "256c" ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm'
fi

# Color and symbol definitions
case "$TERM" in
    xterm-256color)
        # Color definitions (taken from Color Bash Prompt HowTo).
        # Some colors might look different of some terminals.
        # Normal Colors
        BLACK="\001\e[0;30m\002";
        RED="\001\e[0;31m\002";
        GREEN="\001\e[0;32m\002";
        YELLOW="\001\e[0;33m\002";
        BLUE="\001\e[0;34m\002";
        PURPLE="\001\e[0;35m\002";
        CYAN="\001\e[0;36m\002";
        WHITE="\001\e[0;37m\002";
        # Bold
        BBLACK="\001\e[1;30m\002";
        BRED="\001\e[1;31m\002";
        BGREEN="\001\e[1;32m\002";
        BYELLOW="\001\e[1;33m\002";
        BBLUE="\001\e[1;34m\002";
        BPURPLE="\001\e[1;35m\002";
        BCYAN="\001\e[1;36m\002";
        BWHITE="\001\e[1;37m\002";
        # Background
        ON_BLACK="\001\e[40m\002";
        ON_RED="\001\e[41m\002";
        ON_GREEN="\001\e[42m\002";
        ON_YELLOW="\001\e[43m\002";
        ON_BLUE="\001\e[44m\002";
        ON_PURPLE="\001\e[45m\002";
        ON_CYAN="\001\e[46m\002";
        ON_WHITE="\001\e[47m\002";
        # Other ([✘] / \342\234\227, [✔] / \342\234\223)
        FANCYX="\342\234\227";
        CHECKMARK="\342\234\223";
        ALERT=${BWHITE}${ON_RED};
        # Color date/time information in history command output
        export HISTTIMEFORMAT="$(echo -e ${CYAN})[%F %T]$(echo -e ${NC})  ";;
esac


# Check for color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

# Please note that __prompt_command function uses color names defined earlier
if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=__prompt_command
else
    PS1='\u@\h:\w\$ '
fi
#unset color_prompt force_color_prompt


# Disable pausing the screen (Ctrl-s) to make it available for much more useful
# (readline) function: cycling forward through the matches. This is to
# complement searching back through the history of commands with Ctrl+r.
# http://www.skorks.com/2009/09/bash-shortcuts-for-maximum-productivity/#comment-587673785
/bin/stty -ixon


# Make less the default pager, and specify some useful defaults.
less_options=(
# If the entire text fits on one screen, just show it and quit. (Be more like
# "cat" and less like "more".)
    --quit-if-one-screen

# Do not clear the screen first.
    --no-init

# Like "smartcase" in Vim: ignore case unless the search pattern is mixed.
    --ignore-case

# Do not automatically wrap long lines.
    --chop-long-lines

# Allow ANSI colour escapes, but no other escapes.
    --RAW-CONTROL-CHARS

# Do not complain when we are on a dumb terminal.
    --dumb
)
export LESS="${less_options[*]}"
unset less_options
export PAGER="less"
# Make "less" transparently handle non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN="|/usr/bin/lesspipe.sh %s"


# Set your locale
#export LANG="en_US.utf8"
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


# Work: Add hostname completion to my scripts
[ -e ~/bin/si ] && complete -F _known_hosts si
[ -e ~/bin/sn ] && complete -F _known_hosts sn
[ -e ~/bin/sc ] && complete -F _known_hosts sc
[ -e ~/bin/lopr ] && complete -F _known_hosts lopr


# Add texlive to the environment
#if [ -d /usr/local/texlive/2014/bin/x86_64-linux ]; then
#    export PATH=/usr/local/texlive/2014/bin/x86_64-linux:$PATH
#    export MANPATH=/usr/local/texlive/2014/texmf-dist/doc/man:$MANPATH
#    export INFOPATH=/usr/local/texlive/2014/texmf-dist/doc/info:$INFOPATH
#fi


# fix for > Dropbox 2.7.x indicator problems
# https://bugs.launchpad.net/elementaryos/+bug/1357938/comments/10
export DROPBOX_USE_LIBAPPINDICATOR=1


# Log terminal session
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

