#!/bin/bash

if [ ! -d "$HOME/.vim" ]; then
  git clone --recursive git@github.com:bling/dotvim.git $HOME/.vim
  if [ ! -f "$HOME/.vimrc" ]; then
    echo -e "let g:dotvim_settings={}\nlet g:dotvim_settings.version=1\nsource ~/.vim/vimrc" > $HOME/.vimrc
  fi
fi
if [ ! -d "$HOME/.nvm" ]; then
  git clone https://github.com/creationix/nvm.git $HOME/.nvm
fi
if [ ! -d "$HOME/.rbenv" ]; then
  git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
fi
if [ -n "$ZSH_VERSION" ]; then
  if [ ! -d "$HOME/.zprezto" ]; then
    git clone --recursive git@github.com:bling/prezto.git $HOME/.zprezto
    ln -s $HOME/.zprezto/runcoms/zlogin $HOME/.zlogin
    ln -s $HOME/.zprezto/runcoms/zlogout $HOME/.zlogout
    ln -s $HOME/.zprezto/runcoms/zpreztorc $HOME/.zpreztorc
    ln -s $HOME/.zprezto/runcoms/zprofile $HOME/.zprofile
    ln -s $HOME/.zprezto/runcoms/zshenv $HOME/.zshenv
    ln -s $HOME/.zprezto/runcoms/zshrc $HOME/.zshrc
  fi
fi

source $HOME/.nvm/nvm.sh

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
