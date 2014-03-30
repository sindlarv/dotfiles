# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export EDITOR="vim"

# Set terminal based on number of colors detected
if [ `tput colors` -eq 256 ]; then
    export TERM='xterm-256color'
elif [ `tput colors` -gt 80 ]; then
    export TERM='xterm-88color'
else
    export TERM='xterm'
fi

#---------------------
# SSH Keychain
#----------------------
# https://spaces.seas.harvard.edu/display/USERDOCS/Storing+Your+Keys+-+SSH-Agent,+Agent+Forwarding,+and+Keychain

# find the keychain script
KEYCHAIN=
[ -x /usr/bin/keychain ] && KEYCHAIN=/usr/bin/keychain
[ -x ~/bin/keychain ] && KEYCHAIN=~/bin/keychain
KEYCHAIN_ARGS="--nogui"

HOSTNAME=`hostname`

# keys to use
if [ "$HOSTNAME" == "T43" ]; then
    CERTFILES="id_rsa"
else
    CERTFILES="Z89183 private"
fi

if [ -n $KEYCHAIN ] ; then

#
# If there's already a ssh-agent running, then we know we're on a desktop or
# laptop (i.e. a client), so we should run keychain so that we can set up our
# keys, please.
#
    if [ ! "" = "$SSH_AGENT_PID" ]; then

        echo "Keychain: SSH_AGENT_PID is set, so running keychain to load keys."
        $KEYCHAIN $KEYCHAIN_ARGS $CERTFILES && source ~/.keychain/$HOSTNAME-sh

# Else no ssh-agent configured
    else

#
# Offer to run keychain only if no SSH_AUTH_SOCK is set, and only if we aren't
# at the end of a ssh connection with agent forwarding enabled (since then we
# won't need ssh-agent here anyway)
#
        if [ -z $SSH_AUTH_SOCK ]; then
            echo "Keychain: Found no SSH_AUTH_SOCK, so running keychain to \
                  start ssh-agent & load keys."
            $KEYCHAIN $KEYCHAIN_ARGS $CERTFILES && source ~/.keychain/$HOSTNAME-sh
        fi
    fi
fi

unset CERTFILES KEYCHAIN

