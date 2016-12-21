# Note: ~/.profile is executed by the command interpreter for login shells.
# This file however might, or might NOT be read by bash, if ~/.bash_profile or
# ~/.bash_login exists. This behavior is not consistent across all distributions
# and platforms.


# Customize your shell with fancy prompt, aliases, functions etc.
# http://askubuntu.com/a/438170
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi


# Set up Keychain
# Note: Various distributions may have their own scripts, for example in
# /etc/profile[.d], or someplace else. But given that one can never really be
# sure what gets run when logging in graphically, lets check and initialize
# Keychain, if needed.

# Find the keychain script
KEYCHAIN=
[ -x /usr/bin/keychain ] && KEYCHAIN=/usr/bin/keychain
[ -x ~/bin/keychain ] && KEYCHAIN=~/bin/keychain
KEYCHAIN_ARGS="--nogui --agents ssh"

# Keys to use
SSHDIR="$HOME/.ssh"
i=0; for files in ${SSHDIR}/*.pub; do certs[$i]=$(basename ${files%%\.pub}); i=$(expr $i + 1); done
CERTFILES=${certs[*]}

# Check if this is an interactive session, or not
if [[ $- == *i* ]] && [[ -n $KEYCHAIN ]]; then

# If there's already a ssh-agent running, then we know we're on a desktop or
# laptop (i.e. a client), so we should run keychain so that we can set up our
# keys, please.

    if [ ! "" = "$SSH_AGENT_PID" ]; then

        echo "Keychain: SSH_AGENT_PID is set, so running keychain to load keys."
        $KEYCHAIN $KEYCHAIN_ARGS $CERTFILES && source ~/.keychain/$HOSTNAME-sh
        # alternative; somewhat easier if both ssh and gpg agents are required
        #eval $($KEYCHAIN --eval $KEYCHAIN_ARGS $CERTFILES)

# Else no ssh-agent configured
    else

# Offer to run keychain only if no SSH_AUTH_SOCK is set, and only if we aren't
# at the end of a ssh connection with agent forwarding enabled (since then we
# won't need ssh-agent here anyway)

        if [ -z $SSH_AUTH_SOCK ]; then
            echo "Keychain: Found no SSH_AUTH_SOCK, so running keychain to \
                  start ssh-agent & load keys."
            $KEYCHAIN $KEYCHAIN_ARGS $CERTFILES && source ~/.keychain/$HOSTNAME-sh
        fi
    fi
fi

unset CERTFILES KEYCHAIN

