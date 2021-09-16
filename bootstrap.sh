python -c "import sys; assert sys.version_info.major == 3 and sys.version_info.minor >= 6" && python symlinks.py
git clone https://github.com/wbthomason/packer.nvim "$HOME/.local/share/neovim/site/pack/packer/start/packer.nvim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'packadd packer.nvim | PackerSync'
