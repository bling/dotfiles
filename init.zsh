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

function bootstrap-rbenv {
  __clone 'https://github.com/sstephenson/rbenv.git' '.rbenv'
  if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
    mkdir -p "$HOME/.rbenv/plugins"
    git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
  fi
}

# }}}

# PYTHON {{{

function bootstrap-pyenv {
  __clone 'https://github.com/yyuu/pyenv.git' '.pyenv'
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.profile
  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $HOME/.profile
  echo 'export PATH="$HOME/.pyenv/shims:$PATH"' >> $HOME/.profile
  echo 'eval "$(pyenv init -)"' >> $HOME/.profile
}

# }}}

# NODE {{{

function bootstrap-nvm {
  __clone 'https://github.com/creationix/nvm.git' '.nvm'
  touch "$HOME/.profile"
  echo "export NVM_DIR=\"$HOME/.nvm\"" >> $HOME/.profile
  echo "source $HOME/.nvm/nvm.sh" >> $HOME/.profile
}

# }}}

# GO {{{

function bootstrap-gvm {
  zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  echo "source $HOME/.gvm/scripts/gvm" >> $HOME/.profile
}

# }}}

# VIM {{{

function bootstrap-vim {
  __clone 'git@github.com:bling/dotvim.git' '.vim'
  if [ ! -f "$HOME/.vimrc" ]; then
    echo "let g:dotvim_settings={}\nlet g:dotvim_settings.version=1\nsource ~/.vim/vimrc" > $HOME/.vimrc
  fi
}

# }}}

# EMACS {{{

function bootstrap-emacs {
  __clone 'git@github.com:bling/dotemacs.git' '.emacs.d'
}

export ALTERNATE_EDITOR=""
alias emacs='emacsclient -t'
alias emacsw='emacsclient -c -n'

# }}}

# PREZTO {{{

if [ -n "$ZSH_VERSION" ]; then
  if [ ! -d "$HOME/.zprezto" ]; then
    __clone 'git@github.com:bling/prezto.git' '.zprezto'
    pushd
    cd "$BASEDIR/.zprezto"
    git remote add upstream https://github.com/sorin-ionescu/prezto.git
    popd

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi
fi

# }}}

# GIT {{{

if [ ! -f "$HOME/.gitconfig" ]; then
  touch "$HOME/.gitconfig"

  echo "[alias]" >> "$HOME/.gitconfig"
  echo "  br = branch" >> "$HOME/.gitconfig"
  echo "  st = status" >> "$HOME/.gitconfig"
  echo "  co = checkout" >> "$HOME/.gitconfig"
  echo "  ci = commit" >> "$HOME/.gitconfig"
  echo "  log = log --graph" >> "$HOME/.gitconfig"
  echo "  rb = rebase" >> "$HOME/.gitconfig"
  echo "  lg = log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all" >> "$HOME/.gitconfig"

  echo "[branch]" >> "$HOME/.gitconfig"
  echo "  autosetuprebase = always" >> "$HOME/.gitconfig"

  echo "[push]" >> "$HOME/.gitconfig"
  echo "  default = simple" >> "$HOME/.gitconfig"
fi

# }}}


__clone 'https://github.com/Lokaltog/powerline.git' '.powerline'
__symlink '.ctags'
__symlink '.tmux.conf'

export PATH="$BASEDIR/bin:$PATH"
