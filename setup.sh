# Repo: https://github.com/yatimisi2018/dotfiles
set -e

command -v git > /dev/null || { echo "Git not installed"; exit 1; }

# Git clone
if [ ! -d "$HOME/.antigen" ]; then
    git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
fi

if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/yatimisi2018/dotfiles.git $HOME/.dotfiles
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Make directory

DEFAULT_MKDIR=(
    "$HOME/.pip"
    "$HOME/.environment"
)

for ((i=0; i < ${#DEFAULT_MKDIR[@]}; i++))
do
    if [ ! -d ${DEFAULT_MKDIR[$i]} ]; then
        mkdir ${DEFAULT_MKDIR[$i]}
    fi
done

# Made environment
FROM_ENV=(
    "$HOME/.dotfiles/config/gitconfig/gitconfig.user"
    "$HOME/.dotfiles/config/pypirc"
)

TO_ENV=(
    "$HOME/.environment/.gitconfig.user"
    "$HOME/.environment/.pypirc"
)

for ((i=0; i < ${#FROM_ENV[@]}; i++))
do
    if [ ! -f ${TO_ENV[$i]} ]; then
        cp ${FROM_ENV[$i]} ${TO_ENV[$i]}
    fi
done

# Link config
ln -si $HOME/.dotfiles/zsh/zshrc.zsh $HOME/.zshrc
ln -si $HOME/.dotfiles/config/gitconfig/gitconfig $HOME/.gitconfig
ln -si $HOME/.environment/.pypirc $HOME/.pypirc
ln -si $HOME/.dotfiles/config/pip.conf $HOME/.pip/pip.conf
ln -si $HOME/.dotfiles/config/tmux.conf $HOME/.tmux.conf
ln -si $HOME/.dotfiles/config/cz-conventional/czrc $HOME/.czrc

if [ $(uname) != "Darwin" ]; then  # No conky for OSX
    if [ -d "$HOME/.local/share/applications" ]; then  # No conky for no GUI
        ln -s $HOME/.dotfiles/config/conkyrc/conkyrc $HOME/.conkyrc
        ln -s $HOME/.dotfiles/config/conkyrc/conky.desktop $HOME/.local/share/applications
    fi
fi

# Output Tips
ECHO_INSTALL=(
    "nvm"
    "node"
    "npm"
    "npx"
    "pyenv"
    "python"
    "pip"
    "pipenv"
)

echo ""

echo "Down."
echo ""
echo "Please modify '.environment/' in your home dir."
echo ""
echo "And you can install:"

for ((i=0; i < ${#ECHO_INSTALL[@]}; i++))
do
    echo "\t${ECHO_INSTALL[$i]}\c"
    if [ $((($i + 1) % 4)) == 0 ];then
        echo ""
    fi
done

echo "Enjoy this."
