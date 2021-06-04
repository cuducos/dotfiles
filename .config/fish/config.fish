# fish settings
fish_vi_key_bindings

set fish_greeting

set -x __fish_git_prompt_color_branch cyan
set -x __fish_git_prompt_color_branch_detached red

set -x __fish_git_prompt_showdirtystate
set -x __fish_git_prompt_char_dirtystate ●
set -x __fish_git_prompt_color_dirtystate magenta

set -x __fish_git_prompt_showuntrackedfiles
set -x __fish_git_prompt_char_untrackedfiles ◌
set -x __fish_git_prompt_color_untrackedfiles magenta

set -x __fish_git_prompt_char_stagedstate ◌
set -x __fish_git_prompt_color_stagedstate blue

set -x __fish_git_prompt_char_invalidstate ●
set -x __fish_git_prompt_color_invalidstate red

# env
source $HOME/.env.fish

# locale
set --export LC_ALL en_US.UTF-8
set --export LC_CTYPE en_US.UTF-8

# add C headers
set -x CPATH (xcrun --show-sdk-path)/usr/include

# autojump
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# getgist
set --export GETGIST_USER cuducos

# go
set PATH /usr/local/go/bin $PATH
set PATH $HOME/go/bin $PATH

# rust
set PATH $HOME/.cargo/bin $PATH

# pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
status is-login; and pyenv init --path | source
pyenv global 3.9.4

# nodenv
status --is-interactive; and source (nodenv init -|psub)
nodenv global 13.14.0

# poetry
set PATH $HOME/.poetry/bin $PATH

# npm
set PATH $HOME/.npm-global/bin $PATH

# Shopify's dev
source /opt/dev/dev.fish

# aliases
alias ll "ls -laGh"

# nvim nightly
set PATH $HOME/Downloads/nvim-osx64/bin/ $PATH