NEOVIM_PYTHON_VENV=$HOME/.virtualenvs/neovim
DOTFILES_DIR=`pwd`
ARCH=`uname -p`
OS=`uname`

# create directories
find . -type d | grep -v "^./.git" | cut -d/ -f2- | xargs -I@ mkdir -p $HOME/@

# create symlinks
ln -sf $DOTFILES_DIR/.fdignore $HOME/.fdignore
ln -sf $DOTFILES_DIR/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES_DIR/.gitignore_global $HOME/.gitignore_global
find .config -type f | cut -d/ -f2- | xargs -I@ ln -sf $DOTFILES_DIR/.config/@ $HOME/.config/@

# setup neovim's python virttualenv
if [ ! -d $NEOVIM_PYTHON_VENV ]; then
    python3 -m venv $NEOVIM_PYTHON_VENV
    $NEOVIM_PYTHON_VENV/bin/pip install -U pip
    $NEOVIM_PYTHON_VENV/bin/pip install black neovim
fi

# install git-delta (Debian-based x86_64)
if [ "$ARCH" == "x86_64" ]; then
    if [ "$OS" == "Linux"]; then
        wget https://github.com/dandavison/delta/releases/download/0.12.0/git-delta_0.12.0_amd64.deb
        dpkg -i git-delta_0.12.0_amd64.deb
        rm git-delta_0.12.0_amd64.deb
    fi
fi

# setup neovim
nvim --headless -c 'packadd packer.nvim' -c 'quitall'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

