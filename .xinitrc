[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

#
#  Using Caps Lock as Super L (Windows key)
#  http://www.thinkwiki.org/wiki/How_to_get_special_keys_to_work#Using_Caps_Lock_as_Super_L_.28Windows_key.29
HOSTNAME=`hostname`

# keys to use
if [ "$HOSTNAME" == "T43" ]; then
    xmodmap -e "remove Lock = Caps_Lock"
    xmodmap -e "add Mod4 = Caps_Lock"
fi

# RHEL Keychain ssh private key password
# https://bugzilla.redhat.com/show_bug.cgi?id=180776
# https://lists.fedoraproject.org/pipermail/devel/2009-January/019841.html
# ln -s /etc/profile.d/keychain.sh /etc/X11/xinit/xinitrc.d/keychain.sh

