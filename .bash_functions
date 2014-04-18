# vim: set filetype=sh:

# an alternative to pgrep
function p.grep() {
    pids=$(pgrep -d, $@)
    if [ ! -z $pids ]; then
        ps -o pid,args -p $pids
    fi
}

# http://dotfiles.org/~samba/.bash_aliases
# find duplicate files without 'fdupes' {{{
function f.dupes () {
    echo "Scanning for duplicates: $@">&2
    find $@ -type f -exec md5sum {} \; | sort -k 1 | uniq -w 32 -D
}
# }}}

# for each stdin; execute this command... like xargs {{{
function each () {
    singular=0; items=`mktemp`
    while getopts ":s" Option; do
        case $Option in
            s) singular=1;;
        esac
    done

    while read item; do
        [ $singular -eq 0 ] && $@ $item || echo $item > $items;
    done

    [ $singular -ne 0 ] && $@ `cat $items`;

    rm $items
}
# }}}

# opens/selects tunnels as specified {{{
function s.ssh_tunnel () {
    declare usedports=`mktemp` gwport=$(( RANDOM + 1024 )) Destination= GWUser=${SSHDefaultGateway%%@*} GWHost=${SSHDefaultGateway##*@};
    # parse the arguments
    OPTIND=1
    while getopts "g:d:" Option; do
        case $Option in
            g) [[ $OPTARG =~ "@" ]] && GWUser=${OPTARG%%@*} || GWUser=${USER}; GWHost=${OPTARG##*@};;
            d) [[ $OPTARG =~ "@" ]] && DestUser=${OPTARG%%@*} || DestUser=${USER}; DestHost=${OPTARG##*@};;
            *) echo "Unknown option: ${Option} = ${OPTARG}">&2;;
        esac
    done
    [ -z ${DestHost} ] && echo "No destination specified. Please specify.">&2 && return 13;
    [ -z ${GWHost} ] && echo "No gateway specified. Please specify, or set a default.">&2 && return 17;

    echo "Tunnel: ${GWUser}@${GWHost} >> ${DestUser}@${DestHost}">&2

    # make sure we're not trying to bind to an occupied port
    netstat -natl | sed '1,2d' | awk '{print $4}' | sed -r 's/(.*):([0-9]+)/\2/' | sort | uniq > ${usedports}
    while [ `grep ${gwport} ${usedports}` ]; do gwport=$(( RANDOM + 1024 )); done

    # search for existing tunnels to destination, using the same gateway
    `which ps | grep ps` -o pid,command -C ssh | grep -E "[0-9]+:${DestHost}:22 ${GWUser}@${GWHost}" > ${usedports}
    if [[ `wc -l ${usedports} | cut -d ' ' -f 1` -gt "0" ]]; then
        # use existing tunnel
        gwport=`sed -r "s/^(.*) ([0-9]+):${DestHost}:22 (.*)$/\2/" ${usedports}`
        echo "Found gateway port: ${gwport}">&2
    else
        # create a new tunnel
        echo "Creating new tunnel on port: ${gwport}">&2
        ssh -NfL ${gwport}:${DestHost}:22 ${GWUser}@${GWHost}
    fi
    # clear our data from the disk
    rm ${usedports}

    # print the connection info
    echo "${DestUser}@localhost ${gwport}";
}
# }}}

# quick and dirty archiver - lets me datestamp stuff easily {{{
function f.arc () {
    declare stamp= directory= extension='bz2' compress='--bzip2' verbose= delete= target=
    OPTIND=1
    while getopts "d:f:bzsvr" Option; do
#    echo "Reading option: ${Option} ${OPTIND} ${OPTARG}" >&2
    case $Option in
        s) stamp=".[`date +%F\ %H.%M.%S`]";;
        d) directory=${OPTARG};;
        b) compress='--bzip2'; extension='bz2';;
        z) compress='--gzip'; extension='gz';;
        v) verbose='v';;
        r) delete='--remove-files';;
        f) target=${OPTARG};;
        *) echo "Unknown Option: ${Option} [$OPTARG]">&2;;
    esac
    done
#    echo "OPTIND: ${OPTIND}" >&2
    [ -z ${directory} ] && echo "Specify a directory with the -d option.">&2 && return 91;
    [ ! -d ${directory} ] && echo "I make archives out of *directories* [${directory}].">&2 && return 97;
    [ -z ${target} ] && target="`basename "${directory}"`${stamp}.tar.${extension}"
#    echo "Directory: ${directory}" >&2
    echo "Target: ${target}">&2
    tar -c${verbose}f "${target}" ${directory} ${delete} ${compress}
}
# }}}

# open terminals over a tunnel {{{
function s.ssh () {
    # example: s.ssh -d user@dest -g user@gateway
    # grab/create a tunnel and connect
    `s.ssh_tunnel $@ | awk '{ printf ( "ssh %s -p %d" , $1, $2 ); }'`

    # report still-running SSH processes
    `which ps | grep ps` -o pid,euser:15,command -C ssh

}
# }}}

# push files over a tunnel to another machine {{{
function s.scp () {
    # example: s.scp -d user@dest:/path/to/target -g user@gateway /path/to/recv/local
    # example: s.scp [/path/to/send/local/*...] user@dest:/path/to/target user@gateway

    declare -a files
    declare mode= scp_tunnel= scp_cmd=

    until [ $# -eq 0 ]; do
        OPTIND=1
        while getopts "g:d:rs" Option; do
            case $Option in
                g) gateway=${OPTARG};;
                d) destination=${OPTARG};;
                s) mode='send';;
                r) mode='recv';;
            esac
        done
        shift $(( OPTIND - 1 ))
        until [[ $# -eq 0 || $1 =~ ^- && ${#1} -eq 2 ]]; do
            files[${#files[@]}]=${1};
            shift
        done
    done

    # grab/create a tunnel
    tunnel=`s.ssh_tunnel -d ${destination%%:*} -g ${gateway%%:*}`

    [[ $mode == 'send' ]] && scp_cmd="scp ${files[@]} ${tunnel}";
    [[ $mode == 'recv' ]] && scp_cmd="scp ${tunnel} ${files[@]}";
    [[ ${#scp_cmd} -eq 0 ]] && echo "SCP Command has zero length! Something's up...">&2

    # tell me what you're going to do.
    echo "Would do: [[${scp_cmd}]]; but we're still debugging.">&2;

    # report still-running SSH processes
    `which ps | grep ps` -o pid,euser:15,command -C ssh

}
# }}}

# send HUP to the named process {{{
function p.hup () {
    kill -HUP `pidof $1`;
}
# }}}

# remove an inode via inode number {{{
function f.rminode () {
    find . -inum $1 -exec rm -i {} \;
}
# }}}

# create random password {{{
function g.passwd () {
    local l=$1
    local c="A-Za-z0-9"
    #local c="A-Za-z0-9_@#$%^&"
        [ "$l" == "" ] && l=8
        tr -dc ${c} < /dev/urandom | head -c ${l} | xargs
}
# }}}

# quick and dirty unarchiver {{{
function f.unarc() {
    if [ -e "$1" ]; then
        case $1 in
            *.tar.bz2)  tar xvjf $1   ;;
            *.tar.gz)   tar xvzf $1   ;;
            *.bz2)      bunzip2 $1    ;;
            *.rar)      unrar x $1    ;;
            *.gz)       gunzip $1     ;;
            *.tar)      tar xvf $1    ;;
            *.tbz2)     tar xvjf $1   ;;
            *.tgz)      tar xvzf $1   ;;
            *.zip)      unzip $1      ;;
            *.Z)        uncompress $1 ;;
            *.7z)       7z x $1       ;;
            *.lha)      lha x $1      ;;
            *)          echo "'$1' cannot be extracted, unknown format" ;;
        esac
    elif [ -z "$1" ]; then
        echo "Specify a file to be extracted."
    else
        echo "'$1' is an invalid file !"
    fi
}
# }}}

# simple calculator {{{
function g.calc() {
    local result=""
    result="$(printf "scale=3;$*\n" | bc --mathlib | tr -d '\\\n')"
    #                       └─ default (when `--mathlib` is used) is 20

    if [[ "$result" == *.* ]]; then
        # improve the output for decimal numbers
        printf "$result" |
        sed -e 's/^\./0./' `# add "0" for cases like ".5"` \
            -e 's/^-\./-0./' `# add "0" for cases like "-.5"`\
            -e 's/0*$//;s/\.$//' # remove trailing zeros
    else
        printf "$result"
    fi
    printf "\n"
}
# }}}

# Status of last command (for prompt) {{{
# Based on http://www.terminally-incoherent.com/blog/2013/01/14/whats-in-your-bash-prompt/
function __prompt_command() {
    # capture the exit status of the last command
    EXIT="$?"
    PS1=""

    if [ -f ~/bin/t/t.py ]; then PS1+="[$(t | wc -l | sed -e's/ *//')] "; fi

    # if logged in via ssh shows the ip of the client
    if [ -n "${SSH_CLIENT}" ]; then PS1+="${YELLOW}("${$SSH_CLIENT%% *}")${NC}"; fi

    # debian chroot stuff (take it or leave it)
    if [ -f /etc/debian_version ]; then PS1+="${debian_chroot:+($debian_chroot)}"; fi

    # basic information (user@host:path)
    PS1+="${GREEN}\u${NC} ${BLUE}\w${NC} "

    # check if inside git repo
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        # parse the porcelain output of git status
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local Color_On=${GREEN}
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local Color_On=${PURPLE}
        else
            local Color_On=${RED}
        fi

        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD. (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
        fi

        # add the result to prompt
        PS1+="${Color_On}[$branch]${NC} "
    fi

    # prompt $ or # for root
    # fix for exit status upon Ctrl-Z
    # http://unix.stackexchange.com/questions/62173/exit-status-of-148-upon-ctrlz
    if [ $EXIT -eq 0 -o $(kill -l $?) = TSTP ]; then PS1+="${GREEN}\$${NC} "; else PS1+="${BRED}\$${NC} "; fi
}
# }}}

