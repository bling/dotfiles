# vim: fdm=marker

pushd `dirname $0` > /dev/null
BASEDIR=`pwd`
popd > /dev/null

# FUNCTIONS {{{

function __symlink {
  if [ ! -f "$HOME/$1" -a ! -d "$HOME/$1" ]; then
    echo "symlinking $BASEDIR/$1  =>  $HOME/$1"
    ln -s "$BASEDIR/$1" "$HOME/$1"
  fi
}

function __clone {
  if [ ! -d "$BASEDIR/$2" ]; then
    git clone --recursive "$1" "$BASEDIR/$2"
  fi
  __symlink $2
}

# }}}

# RUBY {{{
__clone 'https://github.com/sstephenson/rbenv.git' '.rbenv'
if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
  mkdir -p "$HOME/.rbenv/plugins"
  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# }}}

# NODE {{{

__clone 'https://github.com/creationix/nvm.git' '.nvm'
source $HOME/.nvm/nvm.sh

# }}}

# PREZTO {{{

if [ -n "$ZSH_VERSION" ]; then
  if [ ! -d "$HOME/.zprezto" ]; then
    __clone 'git@github.com:bling/prezto.git' '.zprezto'
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi
fi

# }}}

# VIM {{{

__clone 'git@github.com:bling/dotvim.git' '.vim'
if [ ! -f "$HOME/.vimrc" ]; then
  echo "let g:dotvim_settings={}\nlet g:dotvim_settings.version=1\nsource ~/.vim/vimrc" > $HOME/.vimrc
fi

# }}}

__clone 'https://github.com/Lokaltog/powerline.git' '.powerline'
__symlink '.ctags'
__symlink '.tmux.conf'

