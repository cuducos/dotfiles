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
    sudo apt install -y fish fd-find
    chsh -s /usr/bin/fish spin

    # delta is not available as an apt package
    DELTA_VERSION=0.12.1
    curl -LO https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb
    sudo dpkg -i git-delta_${DELTA_VERSION}_amd64.deb
    rm git-delta_${DELTA_VERSION}_amd64.deb
fi

# setup neovim
nvim --headless -c 'packadd packer.nvim' -c 'quitall'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'UpdateRemotePlugins' -c 'quitall'
