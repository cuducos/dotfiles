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
if test -f $HOME/.env.fish
    source $HOME/.env.fish
end

# make Docker macOS less annoying
if test -f /opt/homebrew/bin/brew
  set -x DOCKER_BUILDKIT 0
end

# brew
if test -f /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
end

# locale
set --export LC_ALL en_US.UTF-8
set --export LC_CTYPE en_US.UTF-8

# add C headers
if type -q xcrun
  set -x CPATH (xcrun --show-sdk-path)/usr/include
end

# autojump
if test -f /usr/local/share/autojump/autojump.fish
  source /usr/local/share/autojump/autojump.fish
end
if test -f /usr/share/autojump/autojump.fish
  source /usr/share/autojump/autojump.fish
end
if test -f /opt/homebrew/share/autojump/autojump.fish
  source /opt/homebrew/share/autojump/autojump.fish
end

# getgist
set --export GETGIST_USER cuducos

# go
set PATH /usr/local/go/bin $PATH
set PATH $HOME/go/bin $PATH

# rust
set PATH $HOME/.cargo/bin $PATH

# pyenv
if type -q pyenv
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
    set PATH $HOME/.pyenv/shims $PATH
    pyenv global 3.9.4
end

# nodenv
set PATH $HOME/.nodenv/bin $PATH
if type -q nodenv
  status --is-interactive; and source (nodenv init -|psub)
  nodenv global 13.14.0
end

# poetry
set PATH $HOME/.poetry/bin $PATH

# pipenv & others
set PATH $HOME/.local/bin $PATH

# npm
set PATH $HOME/.npm-global/bin $PATH

# Shopify's dev
if test -f /opt/dev/dev.fish
  source /opt/dev/dev.fish
  set -x DISABLE_SPRING true
  set -x DISABLE_HYPERWALLET_API_INTERCEPTOR 1
end

# aliases
alias ll "ls -laGh"

# bat
set -x BAT_THEME OneHalfLight

# brew's ruby
set PATH /usr/local/opt/ruby/bin $PATH
