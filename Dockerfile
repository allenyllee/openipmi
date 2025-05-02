FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.8 from the deadsnakes PPA
RUN apt-get update && apt-get install -y \
  software-properties-common && \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt-get update && apt-get install -y \
  python3.8 \
  python3.8-distutils \
  python3.8-dev \
  build-essential \
  autoconf \
  automake \
  libtool \
  pkg-config \
  libncurses-dev \
  libreadline-dev \
  libglib2.0-dev \
  libpopt-dev \
  m4 \
  wget \
  curl \
  git \
  sudo \
  libssl-dev \
  libtool \
  libedit-dev && \
  ln -sf /usr/bin/python3.8 /usr/bin/python && \
  curl https://bootstrap.pypa.io/pip/3.8/get-pip.py -o get-pip.py && \
  python get-pip.py && \
  rm get-pip.py

# Set environment variable for library path
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Create non-root user and allow passwordless sudo
RUN useradd -ms /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Start as root (default user)
USER root
COPY . /workspace
WORKDIR /workspace

RUN ./bootstrap && ./configure --enable-lan && make && make install


# Switch to non-root user after install
USER vscode