function tmpy
    cd (mktemp -d)
    python -m venv .venv/
    source .venv/bin/activate.fish
    pip install -U pip
    if test -n "$argv"
        pip install -U $argv
    end
end
