switch (date +%m)
    case 1 2 12
        set -g sunrise 7
        set -g sunset 16
    case 3 4 5
        set -g sunrise 7
        set -g sunset 16
    case 6 7 8
        set -g sunrise 5
        set -g sunset 20
    case 9 10 11
        set -g sunrise 7
        set -g sunset 17
end

set -l hour (date +%H)
if test $hour -ge $sunrise -a $hour -lt $sunset
    set -g theme latte
else
    set -g theme frappe
end

kitty @ set-colors -c "$HOME"/.config/kitty/catppuccin-"$theme".conf
set -x CATPPUCCIN_THEME $theme
