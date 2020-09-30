alias l='ls -lF'
alias lll='ls -allF'

alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

alias cls='clear'
alias t='cd /tmp'

alias ptt='ssh bbsu@ptt.cc'

if [[ $(uname) == "Darwin" ]]; then
  alias wget='aria2c -x 16 -s 16 --retry-wait=1'
  alias du='ncdu'
  alias ls='exa'
  alias cat='bat'
  alias top='htop'
fi
