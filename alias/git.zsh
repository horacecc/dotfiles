alias gs='git status'
alias gci='git commit -m "feat: Initial commit"'
alias gz='git-cz'

gac() {
    git add --all
    if [ "$1" != "" ]; then
      git commit -m "$1"
    else
      local DATE=$(date +%Y/%m/%d)
      git commit -m "update $DATE" # default commit message is `update`
    fi
}
