# create directories
find . -type d | grep -v "^./.git" | cut -d/ -f2- | xargs -I@ mkdir -p $HOME/@

# create symlinks
DOTFILES_DIR=`pwd`
ln -sf $DOTFILES_DIR/.fdignore $HOME/.fdignore
ln -sf $DOTFILES_DIR/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES_DIR/.gitignore_global $HOME/.gitignore_global
find .config -type f | cut -d/ -f2- | xargs -I@ ln -sf $DOTFILES_DIR/.config/@ $HOME/.config/@

# setup neovim's python virtualenv
NEOVIM_PYTHON_VENV=$HOME/.virtualenvs/neovim
if [ ! -d $NEOVIM_PYTHON_VENV ]; then
    python3 -m venv $NEOVIM_PYTHON_VENV
    $NEOVIM_PYTHON_VENV/bin/pip install -U pip
    $NEOVIM_PYTHON_VENV/bin/pip install black neovim
fi

# install tools on spin
if [ "$SPIN" ]; then
    sudo apt install -y fd-find fish unzip
    sudo chsh -s /usr/bin/fish "$USER"

    # delta is not available as an apt package
    DELTA_VERSION=0.13.0
    ARCH=`uname -m`
    curl -LO https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb
    sudo dpkg -i git-delta_${DELTA_VERSION}_${ARCH}.deb
    rm git-delta_${DELTA_VERSION}_${ARCH}.deb
fi

# setup fish and kitty for diferent os/archs
KITTY_CONF="${HOME}/.config/kitty"

function is_mac() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo 1
    else
        echo 0
    fi
}

function fisher() {
    bin=`which fish`
    if [ `is_mac` == "1" ]; then
        bin="${bin} --login --interactive"
    fi
    echo "${bin}"
}

echo "shell\t$(fisher)" > $KITTY_CONF/shell.conf

FONT_TYPES=(
    "font_family"
    "bold_font"
    "italic_font"
    "bold_italic_font"
)
MAC_FONTS=(
     "FiraCode Nerd Font Mono Retina"
     "FiraCode Nerd Font Mono Bold"
     "FiraCode Nerd Font Mono Light"
     "FiraCode Nerd Font Mono Medium"
 )
LINUX_FONTS=(
    "Fira Code Retina Nerd Font Complete Mono"
    "Fira Code Bold Nerd Font Complete Mono"
    "Fira Code Light Nerd Font Complete Mono"
    "Fira Code SemiBold Nerd Font Complete Mono"
)

if [ ! -f "$KITTY_CONF/fonts.conf" ]; then
    touch $KITTY_CONF/fonts.conf

    for i in {0..3}
    do
        if [ `is_mac` == "1" ]; then
            font="${MAC_FONTS[$i]}"
        else
            font="${LINUX_FONTS[$i]}"
        fi
        echo "${FONT_TYPES[$i]}\t${font}" >> $KITTY_CONF/fonts.conf
    done
fi

# install catppuccin for kitty
if [ ! -f "$KITTY_CONF/catppuccin-latte.conf" ]; then
    curl -Lo $KITTY_CONF/catppuccin-latte.conf https://raw.githubusercontent.com/catppuccin/kitty/main/latte.conf
fi

# setup neovim
nvim --headless -c 'packadd packer.nvim' -c 'quitall'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'UpdateRemotePlugins' -c 'quitall'
