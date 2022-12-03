FROM debian:bullseye-slim AS neovim
ENV NVIM_VERSION 0.8.1
ENV CMAKE_BUILD_TYPE Release
ENV BUILD_REQUIREMENTS "autoconf automake  cmake  curl doxygen g++ gettext git libtool libtool-bin ninja-build pkg-config unzip"
RUN apt update && \
    apt install -y ${BUILD_REQUIREMENTS} && \
    git clone --branch v${NVIM_VERSION} https://github.com/neovim/neovim && \
    cd neovim && \
    make install && \
    rm -rf ../neovim && \
    apt remove -y ${BUILD_REQUIREMENTS} && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

FROM debian:bullseye-slim
COPY --from=neovim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=neovim /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=neovim /usr/local/bin/nvim /usr/local/bin/nvim
RUN apt update && \
    apt install -y curl fd-find gcc git python3 python3-venv wget && \
    ln -s $(which fdfind) /usr/local/bin/fd && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash cuducos
USER cuducos
WORKDIR /home/cuducos/dotfiles/
ADD . .
CMD ./bootstrap.sh
