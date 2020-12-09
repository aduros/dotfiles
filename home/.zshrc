# Setup run in all interactive shells.
#
# Environment variables should go in .zshenv.
#
# NOTE: This file is distributed, don't put passwords in here!

alias config="git --git-dir=$HOME/data/.config.git --work-tree=$HOME"

# Set default args on existing commands
alias cp="cp -r"
alias df="df -h"
alias du="du -bhs"
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
alias feh="feh --scale-down"
alias sxiv="sxiv -b"
alias ip="ip -color=auto"

# Alias certain commands to run through i3-tabbed
alias feh="i3-tabbed feh"
alias sxiv="i3-tabbed sxiv"
alias mpv="i3-tabbed mpv"
alias zathura="i3-tabbed zathura"

# New basic commands
alias e="ls"
alias v="$EDITOR"
alias trash="mv -t ~/trash -iv --"
alias freezer="mv -t ~/freezer -iv --"

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
    local dir=`mktemp --directory /tmp/dir-XXX`
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

lfcd () {
    local file="$HOME/.cache/lf-last-dir-path"
    lf -last-dir-path "$file" "$@"
    local dir=`cat "$file"`
    cd "$dir"
}
# Passed by i3's launcher keybinds
if [ "$_BRUNO_RUN_LF" ]; then
    unset _BRUNO_RUN_LF
    lfcd
fi
if [ "$_BRUNO_RUN_EDITOR" ]; then
    unset _BRUNO_RUN_EDITOR
    $EDITOR ~/data/index.md
fi

# Prompt
autoload -U colors && colors
PS1=""
if [ `whoami` != "bruno" ]; then
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

# If we're running in X, automatically alert when a command ends on another workspace
if [ -n "$WINDOWID" ]; then
    precmd () {
        local exitCode="$?"
        # TODO: Run in background?
        if [ "`xdotool get_desktop`" != "`xdotool get_desktop_for_window $WINDOWID`" ]; then
            local icon=`[ "$exitCode" = 0 ] && echo terminal || echo error`
            local lastCommand=`history | tail -n 1 | sed -e 's/^\s*[0-9]\+\s*//'`
            notify-send --urgency=low -i "$icon" "$lastCommand"
            if [ "$exitCode" != 0 ]; then
                echo -ne "\a" # Many terminals signal the workspace as urgent on a bell character
            fi
        fi
    }
fi

# Update the window title
preexec () {
    local title=""
    if [ `whoami` != "bruno" ]; then
        title="`whoami`"
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

# CTRL-H: cd ..
_go_up () {
    cd ..
    zle reset-prompt
}
zle -N _go_up
bindkey '^h' _go_up

# Setup z: https://github.com/rupa/z
_Z_DATA="$HOME/.cache/z_data"
. ~/.config/shell/z.sh

# CTRL-Z: complete the current word with z
z_word_complete () {
    tokens=(${(z)LBUFFER})
    lastWord="${tokens[-1]}"
    if [ "$lastWord" ]; then
        result=`z -e -- "$lastWord"`
        if [ "$result" ]; then
            if [ "$#tokens" = 1 ]; then
                # If it's the only word, cd there immediately
                cd "$result"
                LBUFFER=""
                zle reset-prompt
            else
                # Otherwise expand the word only
                tokens[-1]="$result/"
                LBUFFER="${tokens[@]}"
                # zle reset-prompt
                # return 0
            fi
        fi
    fi
}
zle -N z_word_complete
bindkey '^z' z_word_complete

source ~/.config/shell/fzf/completion.zsh
source ~/.config/shell/fzf/key-bindings.zsh

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
