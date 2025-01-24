function bu
    printf "\n ==> Updating Homebrew\n"
    brew update
    printf "\n ==> Updating Homebrew installed formulas\n"
    brew upgrade
    printf "\n ==> Cleaning Homebrew cache\n"
    brew cleanup -s
    du -hd0 (brew --cache)
    rm -rfv (brew --cache)
end
