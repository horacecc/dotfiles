# Dotfiles

> My config files

## Install

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git and run setup script

You can clone the repository wherever you want.
I like to keep it in `~/.dotfiles`.
```bash
git clone https://github.com/yatimisi2018/dotfiles && cd dotfiles && sh bootstrap.sh
```

To update, cd into your local dotfiles repository and then:
```bash
sh bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:
```bash
sh bootstrap.sh -f
```

## Setup

- Modify `.environment/` in your home dir

- Options:
    1. If use GPG for git.
        - run `cp $DOTFILES/config/gitconfig/gitconfig.user.signingkey ~/.environment/.gitconfig.user`
        - Modify `~/.environment/.gitconfig.user`

## Feedback

