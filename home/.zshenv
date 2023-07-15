# This file is run both on login and when opening a new terminal
#
# NOTE: This file is distributed, don't put passwords in here!

if [ -f "$HOME/.profile.secrets" ]; then
    source "$HOME/.profile.secrets"
fi

if [ -f /opt/homebrew/bin/brew ]; then
    eval `/opt/homebrew/bin/brew shellenv`
fi

export PATH="$HOME/bin:$HOME/bin/native/`uname`-$CPUTYPE:$HOME/.local/bin:$PATH"

export PATH="$HOME/Library/Python/3.8/bin:$PATH"

# Android development
export ANDROID_HOME="$HOME/private/android-sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# 2DKit development
# export PATH="$HOME/local/2DKit/installer/extras/linux64/command/data:$PATH"

# JS development
export NODE_PATH="$HOME/.local/lib/node_modules:$NODE_PATH"

# Rust development
export PATH="$HOME/.cargo/bin:$PATH"

# WASM-4
export WASI_SDK_PATH="$HOME/private/wasi-sdk-15.0"

# Put all nested bin directories under ~/{data,local,private}/apps/*/bin into the path
for apps_dir in ~/{data,local,private}/apps; do
    if [ -d "$apps_dir" ]; then
        for bin in `find "$apps_dir" -maxdepth 2 -name bin`; do
            export PATH="$bin:$PATH"
        done
    fi
done
unset apps_dir bin

if [ `command -v nvim` ]; then
    export EDITOR="nvim"
else
    export EDITOR="nano"
fi

# Use the homebrew version of less which has support for key remapping
if [ -x /opt/homebrew/bin/less ]; then
    export PAGER="/opt/homebrew/bin/less"
else
    export PAGER="less"
fi

export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

export FZF_DEFAULT_OPTS="--tiebreak=index \
    --bind=ctrl-t:down,ctrl-n:up,ctrl-space:toggle+down,ctrl-h:backward-word,ctrl-s:forward-word \
    --no-info --no-bold --color 16 --color gutter:-1 --color hl:6,hl+:reverse:6 \
    --color fg+:reverse:-1,bg+:-1 --color header:8,info:8,border:8 --color marker:reverse:13 \
    --color spinner:14,prompt:4 --pointer ' ' --marker ' '"
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_PREVIEW_COMMAND="bat --plain --theme base16 --color always -- {}" # Used by fzf.vim

# Forces fd to use base16 colors
export LS_COLORS=""
