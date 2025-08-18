# fish settings
fish_vi_key_bindings

set fish_greeting

set --export __fish_git_prompt_color_branch cyan
set --export __fish_git_prompt_color_branch_detached red

set --export __fish_git_prompt_showdirtystate
set --export __fish_git_prompt_char_dirtystate ●
set --export __fish_git_prompt_color_dirtystate magenta

set --export __fish_git_prompt_showuntrackedfiles
set --export __fish_git_prompt_char_untrackedfiles ◌
set --export __fish_git_prompt_color_untrackedfiles magenta

set --export __fish_git_prompt_char_stagedstate ◌
set --export __fish_git_prompt_color_stagedstate blue

set --export __fish_git_prompt_char_invalidstate ●
set --export __fish_git_prompt_color_invalidstate red

# env
if test -f $HOME/.env.fish
    source $HOME/.env.fish
end
set --export EDITOR (command -v nvim || command -v vim || echo vi)
set PATH $HOME/.local/bin $PATH

# brew
if test -f /opt/homebrew/bin/brew
    set --export HOMEBREW_NO_AUTO_UPDATE 1
    eval (/opt/homebrew/bin/brew shellenv)
end

# locale
set --export LC_ALL en_US.UTF-8
set --export LC_CTYPE en_US.UTF-8

# add C headers
if type -q xcrun
    set --export CPATH (xcrun --show-sdk-path)/usr/include
end

# autojump
if test -f /usr/local/share/autojump/autojump.fish
    source /usr/local/share/autojump/autojump.fish
end

# ripgrep
set --export RIPGREP_CONFIG_PATH $HOME/.ripgreprc

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
    pyenv global 3.12.7
end

# nodenv
set PATH $HOME/.nodenv/bin $PATH
if type -q nodenv
    status --is-interactive; and source (nodenv init -|psub)
    nodenv global 18.20.2
end

# aliases
alias ll "ls -laGh"
alias tmp "cd (mktemp -d)"
alias g git

# bat
set --export BAT_THEME OneHalfLight

# direnv
if type -q direnv
    direnv hook fish | source
end

# minha receita
if type -q minha-receita
    minha-receita completion fish | source
end

# wed
if type -q wed
    if [ (uname -o | string lower) = darwin ]
        set -l WED_NOTIFICATION_FILE $HOME/.last_wed_notification
        set -l NOW (date +%s)
        set -l ONE_HOUR 3600

        if [ ! -e $WED_NOTIFICATION_FILE ]
            echo 0 >$WED_NOTIFICATION_FILE
        end

        set -l LAST_WED_NOTIFICATION (cat $WED_NOTIFICATION_FILE)
        if [ $NOW -gt (math $LAST_WED_NOTIFICATION + $ONE_HOUR) ]
            wed notify
            echo $NOW >$WED_NOTIFICATION_FILE
        end
    end
end
