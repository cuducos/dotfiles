FROM debian:bullseye-slim AS neovim
ENV NVIM_VERSION 0.7.0
ENV CMAKE_BUILD_TYPE Release
ENV BUILD_REQUIREMENTS "ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen"
RUN apt update && \
    apt install -y git ${BUILD_REQUIREMENTS} && \
    git clone --branch v${NVIM_VERSION} https://github.com/neovim/neovim && \
    cd neovim && \
    make install && \
    rm -rf ../neovim && \
    apt remove -y git ${BUILD_REQUIREMENTS} && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

FROM golang:1.18-bullseye AS gh
RUN git clone https://github.com/cli/cli.git cli && \
    cd cli && \
    make install && \
    rm -rf ../cli

FROM golang:1.18-bullseye
COPY --from=neovim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=neovim /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=neovim /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=gh /usr/local/bin/gh /usr/local/bin/gh
RUN apt update && \
    apt install -y curl fd-find gcc git python3 python3-venv wget && \
    ln -s $(which fdfind) /usr/local/bin/fd && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash dummy
USER dummy
WORKDIR /home/dummy/dotfiles/
ADD . .
CMD ./bootstrap.sh
