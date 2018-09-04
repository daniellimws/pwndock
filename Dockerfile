FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt -y install locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# create tools directory
RUN mkdir ~/tools

# base tools
RUN apt update \
    && apt -y install vim patchelf netcat socat strace ltrace curl wget git gdb \
    && apt -y install man sudo inetutils-ping \
    && apt clean

RUN apt update \
    && apt -y install python-dev python-pip \
    && apt -y install python3-dev python3-pip \
    && apt clean

RUN python3 -m pip install --upgrade pip
RUN python -m pip install --upgrade pip

RUN apt update \
    && apt -y install gcc-multilib g++-multilib \
    && apt clean

# libc6-dbg & 32-bit libs
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt -y install libc6-dbg libc6-dbg:i386 glibc-source \
    && apt clean \
    && tar -C /usr/src/glibc/ -xvf /usr/src/glibc/glibc-*.tar.xz

# Keystone, Capstone, and Unicorn
RUN apt -y install git cmake gcc g++ pkg-config libglib2.0-dev
RUN cd ~/tools \
    && wget https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh \
    && bash ./update-trinity.sh
RUN ldconfig

# Z3
RUN cd ~/tools \
    && git clone --depth 1 https://github.com/Z3Prover/z3.git && cd z3 \
    && python scripts/mk_make.py --python \
    && cd build; make && make install

# pwntools
RUN python -m pip install pwntools

# one_gadget
RUN apt update \
    && apt install -y ruby-full \
    && apt clean
RUN gem install one_gadget

# arm_now
RUN python3 -m pip install arm_now

RUN apt update \
    && apt install -y e2tools qemu \
    && apt clean

# Install tmux from source
RUN apt update \
    && apt -y install libevent-dev libncurses-dev \
    && apt clean

RUN TMUX_VERSION=$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
    && wget https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz \
    && tar zxvf tmux-$TMUX_VERSION.tar.gz \
    && cd tmux-$TMUX_VERSION \
    && ./configure && make && make install \
    && cd .. \
    && rm -rf tmux-$TMUX_VERSION* \
    && echo "tmux hold" | dpkg --set-selections # disable tmux update from apt

# Ripgrep
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb \
    && dpkg -i ripgrep_0.9.0_amd64.deb \
    && rm ripgrep_0.9.0_amd64.deb

# GEF
RUN cd ~/tools \
    && git clone --depth 1 https://github.com/hugsy/gef.git \
    && echo "source ~/tools/gef/gef.py" > ~/.gdbinit

RUN python3 -m pip install ropper

# Binwalk
RUN cd ~/tools \
    && git clone --depth 1 https://github.com/devttys0/binwalk && cd binwalk \
    && python3 setup.py install

# Radare2
RUN cd ~/tools \
    && git clone --depth 1 https://github.com/radare/radare2 && cd radare2 \
    && ./sys/install.sh

# zsh
RUN apt update \
    && apt install -y zsh \
    && apt clean \
    && chsh -s $(which zsh)

RUN /bin/sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' /root/.zshrc

# Install dotfiles
# RUN cd ~/tools \
#     && git clone --depth 1 https://github.com/Grazfather/dotfiles.git \
#     && bash ~/tools/dotfiles/init.sh

# RUN echo 'export PS1="[\[\e[34m\]\u\[\e[0m\]@\[\e[33m\]\H\[\e[0m\]:\w]\$ "' >> /root/.zshrc

# Bat
RUN cd ~/tools \
    && curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
        | grep "browser_download_url.*deb" \
        | cut -d : -f 2,3 \
        | grep -v musl \
        | grep amd64 \
        | tr -d '"\"' \
        | wget -qi - -O bat.deb \
    && sudo dpkg -i bat.deb
# fzf
RUN cd ~/tools \
    && rm -rf fzf \
    && git clone --depth 1 https://github.com/junegunn/fzf.git fzf \
    && fzf/install

RUN echo "\n# fzf aliases" >> /root/.zshrc \
    && echo "alias preview=\"fzf --preview 'bat --color \\\"always\\\" {}'\"" >> /root/.zshrc \
    && echo "export FZF_DEFAULT_OPTS=\"--bind='ctrl-o:execute(vim {})+abort'\"" >> /root/.zshrc

# virtualenvwrapper
RUN pip install virtualenvwrapper

RUN echo "\n # virtualenvwrapper" >> /root/.zshrc \
    && echo "export WORKON_HOME=$HOME/.virtualenvs" >> /root/.zshrc \
    && echo "export PROJECT_HOME=$HOME/Devel" >> /root/.zshrc \
    && echo "source /usr/local/bin/virtualenvwrapper.sh" >> /root/.zshrc

# angr
RUN cd ~/tools \
    && /bin/bash -c "source /root/.zshrc && source /usr/local/bin/virtualenvwrapper.sh && mkvirtualenv angr && pip install angr"

# tldr
RUN pip install tldr

# work env
WORKDIR /root/ctfs
