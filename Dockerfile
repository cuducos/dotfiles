FROM debian:bullseye-slim AS neovim
ENV NVIM_VERSION v0.8.1
ENV CMAKE_BUILD_TYPE Release
ENV BUILD_REQUIREMENTS "cmake curl gcc gettext git ninja-build unzip"
RUN apt update && \
    apt install -y ${BUILD_REQUIREMENTS} && \
    git clone --branch ${NVIM_VERSION} https://github.com/neovim/neovim && \
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
    apt install -y curl fd-find gcc git nodejs npm python3 python3-venv wget && \
    ln -s $(which fdfind) /usr/local/bin/fd && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash cuducos
USER cuducos

WORKDIR /home/cuducos/dotfiles/
ADD . .
CMD ./bootstrap.sh
