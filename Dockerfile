FROM debian:bullseye-slim AS neovim
ENV NVIM_VERSION=v0.10.3
ENV CMAKE_BUILD_TYPE=Release
ENV BUILD_REQUIREMENTS="cmake curl gettext git ninja-build unzip"
RUN apt-get update && \
    apt-get install -y ${BUILD_REQUIREMENTS} && \
    git clone --branch ${NVIM_VERSION} https://github.com/neovim/neovim && \
    cd neovim && \
    make && \
    make install && \
    rm -rf ../neovim && \
    apt-get remove -y ${BUILD_REQUIREMENTS} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt-get/lists/*

FROM golang:1.23-bookworm
COPY --from=neovim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=neovim /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=neovim /usr/local/bin/nvim /usr/local/bin/nvim
RUN apt-get update && \
    apt-get install -y curl gcc git nodejs npm python3 python3-venv unzip && \
    rm -rf /var/lib/apt-get/lists/* && \
    useradd -ms /bin/bash cuducos

USER cuducos
WORKDIR /home/cuducos/dotfiles/
ADD . .

CMD ["python3", "bootstrap.py"]
