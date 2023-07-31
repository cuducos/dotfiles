FROM debian:bullseye-slim AS neovim
ENV NVIM_VERSION v0.9.1
ENV CMAKE_BUILD_TYPE Release
ENV BUILD_REQUIREMENTS "cmake curl gettext git ninja-build unzip"
RUN apt update && \
    apt install -y ${BUILD_REQUIREMENTS} && \
    git clone --branch ${NVIM_VERSION} https://github.com/neovim/neovim && \
    cd neovim && \
    make && \
    make install && \
    rm -rf ../neovim && \
    apt remove -y ${BUILD_REQUIREMENTS} && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

FROM golang:1.20-bullseye
COPY --from=neovim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=neovim /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=neovim /usr/local/bin/nvim /usr/local/bin/nvim
RUN apt update && \
    apt install -y curl fd-find gcc git nodejs npm python3 python3-venv unzip wget && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y && \
    ln -s $(which fdfind) /usr/local/bin/fd && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash cuducos
USER cuducos

WORKDIR /home/cuducos/dotfiles/
ADD . .
CMD ./bootstrap.sh
