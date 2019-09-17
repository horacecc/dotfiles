#powerlevel19k configuration

POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time pyenv virtualenv)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="$ "
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
VIRTUAL_ENV_DISABLE_PROMPT=1
POWERLEVEL9K_PYTHON_ICON='\UE73C'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
ZLE_RPROMPT_INDENT=0

# optionally set DEFAULT_USER in ~/.zshrc to your regular username to hide the “user@hostname” info when you’re logged in as yourself on your local machine.
DEFAULT_USER=y

# 自動補字
source $autosuggestions/zsh-autosuggestions.zsh

# 使用 Syntax Highlighting
source $highlighting/zsh-syntax-highlighting.zsh

PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

eval "$(pipenv --completion)"

plugins=(
  zsh-autosuggestions
  autojump
  zsh-syntax-highlighting
)
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

source $ZSH/oh-my-zsh.sh

source $ZSHPATH/.alias
source $ZSHPATH/help/.help
source $ZSHPATH/copyFile/.new
source $ZSHPATH/build/.build
source ~/powerlevel10k/powerlevel10k.zsh-theme

