## Load antigen
source "$HOME/.antigen/bin/antigen.zsh"

## Load the oh-my-zsh's library.
antigen use oh-my-zsh

## Load plugins
antigen bundle pip
antigen bundle docker
antigen bundle docker-compose
antigen bundle web-search
antigen bundle lukechilds/zsh-nvm
antigen bundle qoomon/zsh-lazyload
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

## Load theme config
source "$HOME/.dotfiles/zsh/theme.zsh"

## Set theme
antigen theme denysdovhan/spaceship-prompt

## Apply settings
antigen apply

## Load custom settings
for zsh in ~/.dotfiles/zsh/{alias,note,config}.zsh; do
    [ -r "$zsh" ] && source "$zsh"
done
unset zsh

for f in $HOME/.dotfiles/zsh/environmentals/*.zsh; do source $f; done

load_node() {
  source "$HOME/.dotfiles/zsh/environmentals/lazyload/node.zsh"
}

load_python() {
  source "$HOME/.dotfiles/zsh/environmentals/lazyload/python.zsh"
}

lazyload nvm node npm npx git-cz ng -- 'load_node'
lazyload pyenv python pip pipenv ipython bpython -- 'load_python'
