NEOVIM_PYTHON_VENV=$HOME/.virtualenvs/neovim
DOTFILES_DIR=`pwd`

# create directories
find . -type d | grep -v "^./.git" | cut -d/ -f2- | xargs -I@ mkdir -p $HOME/@

# create symlinks
ln -sf $DOTFILES_DIR/.fdignore $HOME/.fdignore
ln -sf $DOTFILES_DIR/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES_DIR/.gitignore_global $HOME/.gitignore_global
find .config -type f | cut -d/ -f2- | xargs -I@ ln -sf $DOTFILES_DIR/.config/@ $HOME/.config/@

# setup neovim's python virtualenv
if [ ! -d $NEOVIM_PYTHON_VENV ]; then
    python3 -m venv $NEOVIM_PYTHON_VENV
    $NEOVIM_PYTHON_VENV/bin/pip install -U pip
    $NEOVIM_PYTHON_VENV/bin/pip install black neovim
fi

# install fish on spin
if [ "$SPIN" ]; then
    sudo apt install -y fish
    chsh -s /usr/bin/fish
fi

# setup neovim
nvim --headless -c 'packadd packer.nvim' -c 'quitall'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'UpdateRemotePlugins' -c 'quitall'
