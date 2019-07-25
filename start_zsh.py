import hashlib
import os
from os.path import expanduser

zsh="~/.oh-my-zsh"
autosuggestions="~/.zsh/zsh-autosuggestions"
highlighting="/usr/local/share/zsh-syntax-highlighting"
my_zsh = os.path.split(os.path.realpath(__file__))[0]

hostname = input("Input your hostname:")
github_account = input("Input your github account:")
zshrc_directory = hashlib.md5(hostname.lower().encode("utf-8")).hexdigest()

while(not os.path.exists("{}".format(expanduser(zsh)))):
    zsh = input("Input your on-my-zsh path, or input y/Y install oh-my-zsh:")
    if zsh in ['y', 'Y']:
        os.system("sh -c '$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)'")
        zsh="~/.oh-my-zsh"

while(not os.path.exists("{}".format(expanduser(autosuggestions)))):
    autosuggestions = input("Input your autosuggestions path, or input y/Y install autosuggestions:")
    if autosuggestions in ['y', 'Y']:
        os.system("git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions")
        autosuggestions="~/.zsh/zsh-autosuggestions"

while(not os.path.exists("{}".format(expanduser(highlighting)))):
    highlighting = input("Input your highlighting path, or input y/Y install highlighting:")
    if highlighting in ['y', 'Y']:
        os.system("git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/zsh-syntax-highlighting")
        highlighting="/usr/local/share/zsh-syntax-highlighting"

if not os.path.exists("{0}/.zshrc/{1}/.zshrc".format(my_zsh, zshrc_directory)):
    os.system("mkdir {0}/.zshrc/{1}".format(my_zsh, zshrc_directory))
    os.system("cp {0}/.zshrc/.zshrc {0}/.zshrc/{1}/.zshrc".format(my_zsh, zshrc_directory))

zshrc="""# hostname={0}
export GITPATH=https://github.com/{1}
export ZSHPATH={2}
export PATH=$HOME/.local/bin:$PATH
export ZSH={3}
export autosuggestions={4}
export highlighting={5}

source $ZSHPATH/.zshrc/{6}/.zshrc"""

with open(expanduser('~/.zshrc'), 'w') as f:
    f.write(zshrc.format(hostname,
                         github_account,
                         my_zsh,
                         zsh,
                         autosuggestions,
                         highlighting,
                         zshrc_directory))

print("Success execution!!")
print("You can shell 'exec zsh', refashion your zsh.")
print()

