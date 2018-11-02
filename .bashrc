# vim: set filetype=sh:

# https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29#Startup_scripts

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth
# Don't store the following commands in history
export HISTIGNORE="&:bg:fg:h"
# Append to the history file, don't overwrite it
shopt -s histappend
# For setting history length see HISTSIZE and HISTFILESIZE
export HISTSIZE=1000
export HISTFILESIZE=2000
# Add date/time information to history
export HISTTIMEFORMAT="[%F %T]  "
# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
#shopt -s globstar


# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi


# Define editor
export EDITOR="vim"


# Specific and local configuration files

# Local bash configuration
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

# Include aliases from a separate file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# ... and local aliases, too
if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi

# Include functions from a separate file
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions;
fi
# ... and local functions, too
if [ -f ~/.bash_functions_local ]; then
    . ~/.bash_functions_local
fi


# Enable programmable completion features (you don't need to enable this,
# if it's already enabled in /etc/bash.bashrc and /etc/profile sources
# /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# Set terminal based on number of colors detected
if [ "$(tput colors)c" == "256c" ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm'
fi

# Check for color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429).
    # (Lack of such support is extremely rare, and such a case would tend
    # to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

if [ "$color_prompt" = yes ]; then
    # Source: http://ascii-table.com/ansi-escape-sequences.php
    # Note: Non-printable sequences should be enclosed in \[ and \] (http://unix.stackexchange.com/a/105974).
    #       However, \[ with \] are specific to bash and, in addition, does not seem to work properly with
    #       bash on Mac OS. Better solution is to choose what readline understands, i.e. octal-escapes
    #       \001+\002, or hexa-escapes \x01+\x02.
    # https://superuser.com/questions/301353/escape-non-printing-characters-in-a-function-for-a-bash-prompt
    NC="\001\033[0m\002"
    # Foreground colors
    BLACK="\001\033[0;30m\002"
    RED="\001\033[0;31m\002"
    GREEN="\001\033[0;32m\002"
    YELLOW="\001\033[0;33m\002"
    BLUE="\001\033[0;34m\002"
    PURPLE="\001\033[0;35m\002"
    CYAN="\001\033[0;36m\002"
    WHITE="\001\033[0;37m\002"
    # Bold style
    BBLACK="\001\033[1;30m\002"
    BRED="\001\033[1;31m\002"
    BGREEN="\001\033[1;32m\002"
    BYELLOW="\001\033[1;33m\002"
    BBLUE="\001\033[1;34m\002"
    BPURPLE="\001\033[1;35m\002"
    BCYAN="\001\033[1;36m\002"
    BWHITE="\001\033[1;37m\002"
    # Background colors
    ON_BLACK="\001\033[40m\002"
    ON_RED="\001\033[41m\002"
    ON_GREEN="\001\033[42m\002"
    ON_YELLOW="\001\033[43m\002"
    ON_BLUE="\001\033[44m\002"
    ON_PURPLE="\001\033[45m\002"
    ON_CYAN="\001\033[46m\002"
    ON_WHITE="\001\033[47m\002"
    # Combinations
    ALERT=${BWHITE}${ON_RED}
    # Symbols (bash specific)
    FANCYX="\xE2\x9C\x97" # [✘]
    CHECKMARK="\xE2\x9C\x94" # [✔]
    # Other
    export HISTTIMEFORMAT="$(echo -e ${CYAN}[%F %T]${NC})  "
    # Note: The following function uses the color names, as defined above
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
