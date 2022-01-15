FROM debian:bullseye-slim AS build
ENV NVIM_VERSION 0.6.1
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

FROM debian:bullseye-slim
COPY --from=build /usr/local/share/nvim /usr/local/share/nvim
COPY --from=build /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=build /usr/local/bin/nvim /usr/local/bin/nvim
RUN apt update && \
    apt install -y gcc git python3 && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash dummy
USER dummy
WORKDIR /home/dummy/dotfiles/
ADD . .
CMD ./bootstrap.sh
