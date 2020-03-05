FROM ubuntu:latest

RUN apt update && \
    apt install -y \
        wget git make \
        pandoc pandoc-citeproc \
        fig2dev python3-pygments && \
    apt remove --purge -y .\*-doc$ && \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
    mkdir /install-tl-unx; \
    tar -xf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
    echo "selected_scheme scheme-full" >> /install-tl-unx/texlive.profile; \
    /install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
    rm -r /install-tl-unx; \
    rm install-tl-unx.tar.gz

ENV PATH="/usr/local/texlive/2019/bin/x86_64-linux:${PATH}"

RUN tlmgr update --self; \
    tlmgr update --all

ARG USER_NAME=latex
ARG USER_HOME=/home/latex
ARG USER_ID=1000
ARG USER_GECOS=LaTeX

RUN adduser \
    --home "$USER_HOME" \
    --uid $USER_ID \
    --gecos "$USER_GECOS" \
    --disabled-password \
    "$USER_NAME"

USER ${USER_NAME}

ENV HOME /data

WORKDIR /data

VOLUME ["/data"]