python3 -c "import sys; assert sys.version_info.minor >= 6" && python3 symlinks.py
nvim --headless -c 'packadd packer.nvim' -c 'quitall'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
