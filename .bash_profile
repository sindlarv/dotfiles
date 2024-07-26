# vim: set filetype=sh:

# Customize your shell with fancy prompt, aliases, functions etc.
# http://askubuntu.com/a/438170
if [ -f ~/.bashrc ] && [ $(echo $BASH_VERSION | cut -d. -f1) -lt 4 ]; then
    . ~/.bashrc
fi

# Set up Keychain
eval `keychain --eval --agents ssh --inherit any-once`
