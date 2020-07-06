alias g='git'
alias gl='git l'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'
alias gs='git status'
alias gcl='git clone'
alias gbl='git blame'
alias gbll='git blame -L'
alias gsh='git stash'

alias gp='git push'
alias gpl='git pull'

alias ga='git add'
alias gaa='git add --all'

alias gca='git commit -a'
alias gm='git commit -m'
alias gsm='git commit -S -m'
alias gmi='git commit -m "feat: Initial commit"'
alias gz='git-cz'

gac() {
    git add --all
    if [ "$1" != "" ]; then
      git commit -m "$1"
    else
      local DATE=$(date +%Y/%m/%d-%H:%M:%S)
      git commit -m "update $DATE" # default commit message is `update`
    fi
}

gasc() {
    git add --all
    if [ "$1" != "" ]; then
      git commit -S -m "$1"
    else
      local DATE=$(date +%Y/%m/%d-%H:%M:%S)
      git commit -S -m "update $DATE" # default commit message is `update`
    fi
}

gf() {
    local branch="$1"
    if [ "$branch" != "" ]; then
        git checkout -b "feature/$branch"
    else
        printf "Please input branch_name."
    fi
}
