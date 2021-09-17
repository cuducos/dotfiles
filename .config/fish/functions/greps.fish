function greps
    ps -a | grep $argv[1] | grep -E "^( grep --color=auto $argv[1])"
end
