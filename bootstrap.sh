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

        echo "Done. $HOME/.antigen"
        echo ""
    fi;

    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "Clone: https://github.com/tmux-plugins/tpm > $HOME/.tmux/plugins/tpm";

        command -v git > /dev/null \
         && { git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm;} \
         || ( mkdir "$HOME/.tmux/plugins/tpm" ; curl -#L https://github.com/tmux-plugins/tpm/tarball/master | tar -xz --strip-components 1 -C $HOME/.tmux/plugins/tpm;)

        echo "Done. $HOME/.tmux/plugins/tpm"
        echo ""
    fi;

    # Make directory ----------------------------------------------------------------
    for dir in ~/.{pip,environment}; do
        [ ! -d "$dir" ] && mkdir "$dir" && echo "Done. $dir"
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
            cp ${ENV[$i]} "$ENV_PATH/.$(basename "${ENV[$i]}")" && echo "Done. $ENV_PATH/.$(basename "${ENV[$i]}")"
        fi
    done

    # Link config -------------------------------------------------------------------
    [ ! -d "$HOME/.dotfiles" ] && ln -si "$(dirname "${BASH_SOURCE}")" $HOME/.dotfiles && echo "Done. $HOME/.dotfiles"

    FORM_LINK=(
        "$HOME/.dotfiles/zsh/zshrc.zsh"
        "$HOME/.dotfiles/config/gitconfig/gitconfig"
        "$HOME/.environment/.pypirc"
        "$HOME/.dotfiles/config/pip.conf"
        "$HOME/.dotfiles/config/tmux.conf"
        "$HOME/.dotfiles/config/vim/.vimrc"
        "$HOME/.dotfiles/config/vim/colors"
        "$HOME/.dotfiles/config/cz-conventional/czrc"
    )

    TO_LINK=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.pypirc"
        "$HOME/.pip/pip.conf"
        "$HOME/.tmux.conf"
        "$HOME/.vimrc"
        "$HOME/.vim/colors"
        "$HOME/.czrc"
    )

    for ((i=0; i < ${#FORM_LINK[@]}; i++))
    do
        if [ "$1" == "--force" -o "$1" == "-f" ]; then
            [ ! -f ${TO_LINK[$i]} ] && ln -sh ${FORM_LINK[$i]} ${TO_LINK[$i]} && echo "Done. ${TO_LINK[$i]}"
        else
            ln -si ${FORM_LINK[$i]} ${TO_LINK[$i]} && echo "Done. ${TO_LINK[$i]}"
        fi;
    done

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

    echo "-------------------------------------------------------------------"
    echo "Done."
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
	main -f;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		main;
	fi;
fi;
unset main;
