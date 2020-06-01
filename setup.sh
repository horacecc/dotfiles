# Repo: https://github.com/yatimisi2018/dotfiles
set -e

command -v git > /dev/null || { echo "Git not installed"; exit 1; }

if [ ! -d "$HOME/.antigen" ]; then
    git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
fi

if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/yatimisi2018/dotfiles.git $HOME/.dotfiles
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d "$HOME/.pip" ]; then
    mkdir $HOME/.pip
fi

ln -si $HOME/.dotfiles/zsh/zshrc.zsh $HOME/.zshrc
ln -si $HOME/.dotfiles/config/gitconfig/gitconfig $HOME/.gitconfig
ln -si $HOME/.dotfiles/config/pypirc $HOME/.pypirc
ln -si $HOME/.dotfiles/config/pip.conf $HOME/.pip/pip.conf
ln -si $HOME/.dotfiles/config/tmux.conf $HOME/.tmux.conf
ln -si $HOME/.dotfiles/config/cz-conventional/czrc $HOME/.czrc

if [ ! -f "$HOME/.gitconfig.user" ]; then
    cp $HOME/.dotfiles/config/gitconfig/gitconfig.user $HOME/.gitconfig.user
fi

if [ $(uname) != "Darwin" ]; then  # No conky for OSX
    if [ -d "$HOME/.local/share/applications" ]; then  # No conky for no GUI
        ln -s $HOME/.dotfiles/config/conkyrc/conkyrc $HOME/.conkyrc
        ln -s $HOME/.dotfiles/config/conkyrc/conky.desktop $HOME/.local/share/applications
    fi
fi

echo "Down."
echo ""
echo "Please modify '.gitconfig.user' in your home dir."
echo ""
echo "And you can install:"
echo "    nvm"
echo "    node"
echo "    npm"
echo "    npx"
echo "    pyenv"
echo "    python"
echo "    pip"
echo "    pipenv"
echo "Enjoy this."
