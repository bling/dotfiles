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
if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
  mkdir -p "$HOME/.rbenv/plugins"
  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi
if [ -n "$ZSH_VERSION" ]; then
  if [ ! -d "$HOME/.zprezto" ]; then
    git clone --recursive git@github.com:bling/prezto.git $HOME/.zprezto
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi
fi
if [ ! -d "$HOME/.powerline" ]; then
  git clone https://github.com/Lokaltog/powerline.git $HOME/.powerline
fi

ln -s ./.ctags $HOME/.ctags
ln -s ./.tmux.conf $HOME/.tmux.conf

source $HOME/.nvm/nvm.sh

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
