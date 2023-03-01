#!/bin/sh
if [[ -z "${SPIN}" ]]; then
    curl https://sh.rustup.rs -sSf | sh -s -- -qy
    source $HOME/.cargo/env
fi

python3 bootstrap.py
