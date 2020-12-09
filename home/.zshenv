# This file is run both on login and when opening a new terminal
#
# NOTE: This file is distributed, don't put passwords in here!

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Android development
export ANDROID_HOME="$HOME/apps/android-sdk-linux"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

# 2DKit development
export PATH="$HOME/remote/2DKit/installer/extras/linux64/command/data:$PATH"

# Put all nested bin directories under ~/apps onto the path
if [ -d ~/apps ]; then
    for dir in `find ~/apps -maxdepth 2 -name bin`; do
        PATH="$dir:$PATH"
    done
fi

if [ `command -v nvim` ]; then
    export EDITOR="nvim"
else
    export EDITOR="nano"
fi

export PAGER="less"
if [ `command -v highlight` ]; then
    export LESSOPEN="| highlight %s --out-format ansi --force --no-trailing-nl"
    alias cat="highlight --out-format ansi --force --no-trailing-nl"
fi

export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

export FZF_DEFAULT_OPTS="--bind=ctrl-t:down,ctrl-n:up"
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
