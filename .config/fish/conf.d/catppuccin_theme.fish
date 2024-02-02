switch (date +%m)
    case 01 02 12
        set -g sunrise 7
        set -g sunset 16
    case 03 04 05
        set -g sunrise 7
        set -g sunset 16
    case 06 07 08
        set -g sunrise 5
        set -g sunset 20
    case 09 10 11
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
