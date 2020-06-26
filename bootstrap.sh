# Repo: https://github.com/yatimisi2018/dotfiles
set -e

cd "$(dirname "${BASH_SOURCE}")";

function main() {

    # Clone ---------------------------------------------------------------------
    if [ ! -d "$HOME/.antigen" ]; then
        echo "Clone: https://github.com/zsh-users/antigen > $HOME/.antigen";

        command -v git > /dev/null \
         && { git clone https://github.com/zsh-users/antigen.git $HOME/.antigen;} \
         || ( mkdir "$HOME/.antigen" ; curl -#L https://github.com/zsh-users/antigen/tarball/develop | tar -xz --strip-components 1 -C $HOME/.antigen;)

        echo ""
    fi;

    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "Clone: https://github.com/tmux-plugins/tpm > $HOME/.tmux/plugins/tpm";

        command -v git > /dev/null \
         && { git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm;} \
         || ( mkdir "$HOME/.tmux/plugins/tpm" ; curl -#L https://github.com/tmux-plugins/tpm/tarball/master | tar -xz --strip-components 1 -C $HOME/.tmux/plugins/tpm;)

        echo ""
    fi;

    # Make directory ----------------------------------------------------------------
    for dir in ~/.{pip,environment}; do
        [ ! -d "$dir" ] && mkdir "$dir"
    done

    # Made environment --------------------------------------------------------------
    ENV_PATH="$HOME/.environment"
    ENV=(
        'config/gitconfig/gitconfig.user'
        'config/pypirc'
    )

    for ((i=0; i < ${#ENV[@]}; i++))
    do
        if [ ! -f "$ENV_PATH/.$(basename "${ENV[$i]}")" ]; then
            cp ${ENV[$i]} "$ENV_PATH/.$(basename "${ENV[$i]}")"
        fi
    done

    # Link config -------------------------------------------------------------------
    [ ! -d "$HOME/.dotfiles" ] && ln -si "$(dirname "${BASH_SOURCE}")" $HOME/.dotfiles
    ln -si $HOME/.dotfiles/zsh/zshrc.zsh $HOME/.zshrc
    ln -si $HOME/.dotfiles/config/gitconfig/gitconfig $HOME/.gitconfig
    ln -si $HOME/.environment/.pypirc $HOME/.pypirc
    ln -si $HOME/.dotfiles/config/pip.conf $HOME/.pip/pip.conf
    ln -si $HOME/.dotfiles/config/tmux.conf $HOME/.tmux.conf
    ln -si $HOME/.dotfiles/config/cz-conventional/czrc $HOME/.czrc

    if [ $(uname) != "Darwin" ]; then  # No conky for OSX
        if [ -d "$HOME/.local/share/applications" ]; then  # No conky for no GUI
            ln -s config/conkyrc/conkyrc $HOME/.conkyrc
            ln -s config/conkyrc/conky.desktop $HOME/.local/share/applications
        fi
    fi

    # Output Tips -------------------------------------------------------------------
    OPTIONS_INSTALL=(
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

    for ((i=0; i < ${#OPTIONS_INSTALL[@]}; i++))
    do
        echo "\t${OPTIONS_INSTALL[$i]}\c"
        if [ $((($i + 1) % 4)) == 0 ]; then
            echo "";
        fi;
    done

    echo "Enjoy this."
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	main;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		main;
	fi;
fi;
unset main;
