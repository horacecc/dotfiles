export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER="less -FX"

# My scripts
if [ -d "$DOTFILES/scripts" ]; then
    export PATH="$PATH:$DOTFILES/scripts"
fi

# Fix emacs error
if [[ $TERM = dumb ]]; then
    unset zle_bracketed_paste
fi
