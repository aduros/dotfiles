# Setup run in all interactive shells.
#
# Environment variables should go in .zshenv.
#
# NOTE: This file is distributed, don't put passwords in here!

lfcd () {
    local file="$HOME/.cache/lf-last-dir-path"

    # Run in a subshell so cleanup works as expected
    (
        # The file that will contain all the directories mounted inside of lf
        export LF_MOUNTS=`mktemp`

        cleanup () {
            # Unmount any directories that were mounted inside of lf
            if [ -f "$LF_MOUNTS" ]; then
                while IFS= read -r mnt; do
                    umount "$mnt"
                    rmdir "$mnt"
                done < "$LF_MOUNTS"
                rm "$LF_MOUNTS"
            fi
        }
        trap cleanup EXIT

        lf -last-dir-path "$file" -- "$@"
    )

    cd "`cat "$file"`"
}
# Can be set by i3 to launch lfcd on startup. This should be near the top of this file to run as
# soon as possible.
if [ "$_START_LFCD" ]; then
    unset _START_LFCD
    lfcd
fi

alias config="git --git-dir=$HOME/data/.config.git --work-tree=$HOME"

# Set default args on existing commands
alias cp="cp -r"
alias df="df -h"
alias du="du -bhs"
alias free="free -h"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto -h --group-directories-first --quoting-style=literal"
alias diff="diff --color=auto"
alias mkdir="mkdir -p"
alias ps="ps -eo user,pid,time,command"
alias rm="rm -r"
alias scp="scp -r"
alias tree="tree -C --dirsfirst --noreport"
alias ip="ip -color=auto"

# Alias certain commands to run through i3-tabbed
alias sxiv="i3-tabbed sxiv -b"
alias mpv="i3-tabbed mpv"
alias zathura="i3-tabbed zathura"
alias gimp="i3-tabbed gimp"

# New basic commands
alias e="ls"
alias ea="ls -A"
alias v="$EDITOR"
alias fd="fdfind"
alias trash="mv -t ~/trash -iv --"
# $LESSOPEN input filter breaks tailing, so create a new alias just for tailing
alias follow="less --no-lessopen +F --"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Host specific stuff
# case `hostname -s` in
#     voando|coral)
#         # export JAVA_HOME="/usr/lib/jvm/default-java"
#         # export PATH="$JAVA_HOME/bin:~/apps/maven/bin:$PATH"
#         # export PATH="~/apps/maven/bin:$PATH"
#         ;;
# esac

# Create and enter a temporary workspace directory. Use $OLDPWD or cd - to access the original dir
tmp () {
    mkdir -p ~/trash
    local dir=`mktemp --directory ~/trash/tmp-XXX`
    pushd "$dir" > /dev/null
    "${@:1}"
}

# Swap two file names
swap () {
    local temp=$(mktemp $(dirname "$1")/swap-XXXXXX)
    mv "$1" "$temp"
    mv "$2" "$1"
    mv "$temp" "$2"
}

# Running duc with no arguments launches the gui
duc () {
    if [ "$#" -gt 0 ] && [ "$1" != "gui" ]; then
        command duc "$@"
    else
        if [ "$1" != "gui" ]; then
            local gui="gui"
        fi
        # TODO(2020-12-20): cd to the last open directory if duc supports it
        # https://github.com/zevv/duc/issues/269
        i3-tabbed duc $gui "$@"
    fi
}

# Extract zips and other archives
x () {
    for file in "$@" ; do
        case `file --mime-type -bL -- "$file"` in
        application/x-tar | application/gzip | application/x-bzip2 | application/x-xz)
            tar -x --file "$file" ;;
        application/zip | application/java-archive)
            unzip -- "$file" ;;
        application/x-rar)
            rar x -- "$file" ;;
        application/x-7z-compressed)
            7z x -- "$file" ;;
        *)
            echo Unsupported filetype: "$file"
            return 1 ;;
        esac
    done
}
compctl -/g '*.(tar|tar.gz|tgz|tar.bz2|tbz2|tar.xz|txz|zip|jar|apk|ipa|rar|7z)' x

# Prompt
autoload -U colors && colors
PS1=""
if [ "$USER" != "bruno" ] && [ "$USER" != "ubuntu" ]; then
    PS1="%{$fg[red]%}%n@"
fi
if [ "$SSH_TTY" ]; then
    PS1="$PS1%{$fg[yellow]%}%M:"
fi
PS1="%B$PS1%{$fg[black]%}%B%~%b "

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Make ctrl-left/right work on some terminals
bindkey "^[[1;5C" forward-word
bindkey "^[Oc" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[Od" backward-word
# bindkey "^[^[[D" forward-word
# bindkey "^[^[[C" backward-word

# ctrl-w should stop on dots and slashes
autoload -U select-word-style
select-word-style bash

# History
setopt histignorealldups sharehistory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/shell_history

# Use modern completion system
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

precmd () {
    # Switch to beam cursor
    echo -ne '\e[6 q'

    # If we're running in X, automatically alert when a command ends on another workspace
    if [ -n "$WINDOWID" ]; then
        local exitCode="$?"
        # TODO: Run in background?
        if [ "`xdotool get_desktop`" != "`xdotool get_desktop_for_window $WINDOWID`" ]; then
            local icon=`[ "$exitCode" = 0 ] && echo octopi-ok || echo octopi-error`
            local lastCommand=`history | tail -n 1 | sed -e 's/^\s*[0-9]\+\s*//'`
            notify-send --urgency=low -i "$icon" "Exit code $exitCode" "<tt>$lastCommand</tt>"
            if [ "$exitCode" != 0 ]; then
                echo -ne "\a" # Many terminals signal the workspace as urgent on a bell character
            fi
        fi
    fi
}

# Update the window title
preexec () {
    local title=""
    if [ "$USER" != "bruno" ] && [ "$USER" != "ubuntu" ]; then
        title="$USER"
    fi
    if [ "$SSH_TTY" ]; then
        title="$title@$HOST"
    fi
    if [ "$title" ]; then
        title="$title:"
    fi
    title="$title`print -P %~`"
    if [ "$1" ]; then
        title="$1 - $title"
    fi
    echo -ne "\033];$title\007"
}
preexec

# Same as /etc/zsh_command_not_found but prints a failure message
if [[ -x /usr/lib/command-not-found ]]; then
    command_not_found_handler () {
        [[ -x /usr/lib/command-not-found ]] || return 1
        /usr/lib/command-not-found -- ${1+"$1"} && :
    }
fi

# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
#
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# zstyle ':completion:*:*:git:*' script ~/.config/shell/git/_git

fpath=(~/.config/shell $fpath)

# ~/bin/todo is completely different than the command zsh has completion for
unset '_comps[todo]'

#
# Bindings
#

# Disable ctrl-S XON/OFF flow control
# setopt noflowcontrol
stty -ixon # Works inside of other programs

# Parity with readline
bindkey ^u backward-kill-line

# Dvorak directions
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 't' vi-down-line-or-history
bindkey -M menuselect 'n' vi-up-line-or-history
bindkey -M menuselect 's' vi-forward-char

bindkey ^h backward-word
bindkey ^s forward-word

# CTRL-O: lfcd
_go_lfcd () {
    lfcd
    zle reset-prompt
}
zle -N _go_lfcd
bindkey '^o' _go_lfcd

# CTRL-G: git status
_bind_git () {
    echo
    git status --short --branch
    zle reset-prompt
}
zle -N _bind_git
bindkey '^g' _bind_git

# CTRL-V: vim
_bind_editor () {
    $EDITOR ~/data/index.md
}
zle -N _bind_editor
bindkey '^v' _bind_editor

# Setup z: https://github.com/rupa/z
_Z_DATA="$HOME/.cache/z_data"
touch "$_Z_DATA"
. ~/.config/shell/z.sh

# CTRL-Z: complete the current word with z
_bind_z () {
    local res=`z-history | fzf --tac --reverse --height 40% --prompt "z> " | sed "s|^~/|$HOME/|"`
    if [ "$res" ]; then
        if [ "$LBUFFER" ]; then
            LBUFFER="$LBUFFER${(q)res} "
        else
            res=`echo "$res" `
            cd "$res"
        fi
    fi
    zle reset-prompt
}
zle -N _bind_z
bindkey '^z' _bind_z

_bind_recent () {
    local res=`file-history | fzf --reverse --height 40% --prompt "Hist> " | sed "s|^~/|$HOME/|"`
    if [ "$res" ]; then
        if [ "$LBUFFER" ]; then
            LBUFFER="$LBUFFER${(q)res} "
        else
            o "$res"
        fi
    fi
    zle reset-prompt
}
zle -N _bind_recent
bindkey '^j' _bind_recent

source ~/.config/shell/fzf/completion.zsh
source ~/.config/shell/fzf/key-bindings.zsh

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
