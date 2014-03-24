# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
BLACK='\e[0;30m'        # Black
RED='\e[0;31m'          # Red
GREEN='\e[0;32m'        # Green
YELLOW='\e[0;33m'       # Yellow
BLUE='\e[0;34m'         # Blue
PURPLE='\e[0;35m'       # Purple
CYAN='\e[0;36m'         # Cyan
WHITE='\e[0;37m'        # White

# Bold
BBLACK='\e[1;30m'       # Black
BRED='\e[1;31m'         # Red
BGREEN='\e[1;32m'       # Green
BYELLOW='\e[1;33m'      # Yellow
BBLUE='\e[1;34m'        # Blue
BPURPLE='\e[1;35m'      # Purple
BCYAN='\e[1;36m'        # Cyan
BWHITE='\e[1;37m'       # White

# Background
ON_BLACK='\e[40m'       # Black
ON_RED='\e[41m'         # Red
ON_GREEN='\e[42m'       # Green
ON_YELLOW='\e[43m'      # Yellow
ON_BLUE='\e[44m'        # Blue
ON_PURPLE='\e[45m'      # Purple
ON_CYAN='\e[46m'        # Cyan
ON_WHITE='\e[47m'       # White

# Other
NC="\e[m"                   # Color Reset
SMILEY=":)"                 # :)
FROWNY=":("                 # :(
FANCYX="\342\234\227"       # x
CHECKMARK="\342\234\223"    # \/
ALERT=${BWHITE}${ON_RED}    # Bold White on red background

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

if [ "$color_prompt" = yes ]; then
    #PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # http://stackoverflow.com/questions/22361722/simplifying-advanced-bash-prompt-variable-ps1-code?rq=1
    PS1="${WHITE}\$? \$(if [[ \$? == 0 ]]; then echo \"${GREEN}${CHECKMARK}\"; else echo \"${RED}${FANCYX}\"; fi) $(if [[ ${EUID} == 0 ]]; then echo "${RED}\u"; else echo "${GREEN}\u"; fi)${BLUE} \w \$${NC} "
else
    PS1='\u@\h:\w\$ '
fi
#unset color_prompt force_color_prompt

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

# http://www.skorks.com/2009/09/bash-shortcuts-for-maximum-productivity/#comment-587673785
/bin/stty -ixon

# http://rc98.net/screen
# Commented out (in /etc/bash.bashrc), don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${KCH_HOST}:${PWD}\007"'
    ;;
# special escaping for Screen
screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${KCH_HOST}:${PWD}\033\\"'
    ;;
*)
    ;;
esac


# user locale
#export LANG=
export LC_CTYPE="cs_CZ.utf8"
export LC_NUMERIC="cs_CZ.utf8"
export LC_TIME="cs_CZ.utf8"
export LC_COLLATE="cs_CZ.utf8"
export LC_MONETARY="cs_CZ.utf8"
#export LC_MESSAGES=
export LC_PAPER="cs_CZ.utf8"
export LC_NAME="cs_CZ.utf8"
export LC_ADDRESS="cs_CZ.utf8"
export LC_TELEPHONE="cs_CZ.utf8"
export LC_MEASUREMENT="cs_CZ.utf8"
#export LC_IDENTIFICATION=

# editor
export EDITOR="vim"

