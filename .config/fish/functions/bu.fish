function bu
    printf "\n ==> Updating Homebrew\n"
    brew update
    printf "\n ==> Updating Homebrew installed formulas\n"
    brew upgrade
    printf "\n ==> Cleaning Homebrew cache\n"
    brew cleanup -s
    rm -rfv (brew --cache)
end
