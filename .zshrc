# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(atom bower docker docker-compose git grunt postgres python ruby rvm symfony2 vagrant)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/.composer/vendor/bin"

source $ZSH/oh-my-zsh.sh

if [[ -f $HOME/.zsh_profile ]]; then
  source $HOME/.zsh_profile
fi

if [[ -f $HOME/.zsh_custom ]]; then
  source $HOME/.zsh_custom
fi
