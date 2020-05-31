alias docker-image-clenup='docker rmi $(docker images -f "dangling=true" -q)'
alias dk='docker'
