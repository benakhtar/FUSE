#
# FUSE Dockerfile
#
# https://github.com/norakh/FUSE
#
# authors: Github @MoritzHuppert moritz.huppert@outlook.de
#	   Github @norakh
#
# usage: docker build -t norakh/fuse -f Dockerfile .
#	 docker container run --name fuse -v . /home/user/FUSE -d [docker_image]

# Pull base image.
# old ubuntu version as it contains glibc code
# that is compatible with catch 1 used in HyCC
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Install.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y locales git make wget curl && \
  apt-get install -y libwww-perl && \
  apt-get install -y flex bison default-jdk && \
  apt-get install -y build-essential software-properties-common && \
  add-apt-repository ppa:ubuntu-toolchain-r/test && \
  apt-get install -y gcc-11 g++-11 && \
  
  
RUN \
  apt-get install -y libssl-dev libgoogle-perftools-dev libboost-all-dev libz-dev && \
  rm -rf /var/lib/apt/lists/*

ENV PYTHON_VERSION 3.9.0

#Set of all dependencies needed for pyenv to work on Ubuntu
RUN apt-get update \ 
        && apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 git

# Set-up necessary Env vars for PyEnv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install pyenv
RUN set -ex \
    && curl https://pyenv.run | bash \
    && pyenv update \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash




# Uncomment the en_US.UTF-8 line in /etc/locale.gen
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
# locale-gen generates locales for all uncommented locales in /etc/locale.gen
RUN locale-gen
ENV LANG=en_US.UTF-8

# install gcc
RUN \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 90 --slave /usr/bin/g++ g++ /usr/bin/g++-11

# temp settings: remove later when repository is public


WORKDIR '/home/user'
RUN \
  wget https://github.com/Kitware/CMake/releases/download/v3.27.1/cmake-3.27.1.tar.gz && \
  tar -xzf cmake-3.27.1.tar.gz
WORKDIR '/home/user/cmake-3.27.1'
RUN \
  ./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release && \
  make && \
  make install

# git clone fuse into /home/user/FUSE
WORKDIR '/home/user'
RUN \
  git clone --recurse-submodules -j8 --config core.autocrlf=input https://github.com/benakhtar/FUSE.git

# build
RUN \
  rm -r /home/user/FUSE/extern/MOTION/extern/flatbuffers
WORKDIR '/home/user/FUSE'
RUN \
  python3 setup.py --setup-build

# Define default command.
CMD ["bash"]
