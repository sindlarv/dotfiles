# vim: set filetype=sh:

# Customize your shell with fancy prompt, aliases, functions etc.
# http://askubuntu.com/a/438170
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi


# Set up Keychain
eval `keychain --eval --agents ssh --inherit any-once`
