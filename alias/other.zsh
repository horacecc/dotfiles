alias l='ls -lF'
alias lll='ls -allF'

alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

alias cls='clear'
alias t='cd /tmp'
alias fd='echo ${PWD##*/}'

alias ptt='ssh bbsu@ptt.cc'
[[ $(uname) == "Darwin" ]] && alias wget='aria2c -x 16 -s 16 --retry-wait=1'
[[ $(uname) == "Darwin" ]] && alias du='ncdu'
