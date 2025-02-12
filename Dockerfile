#
# FUSE Dockerfile
#

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
  apt-get install -y gcc-11 g++-11 cmake && \
  apt-get install -y libbz2-dev && \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt-get update && \
  apt-get install -y python3.9 && \
  apt-get install -y libssl-dev libgoogle-perftools-dev libboost-all-dev libz-dev && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y vim

RUN \
  rm /usr/bin/python3 && \
  ln -s /usr/bin/python3.9 /usr/bin/python3

# Uncomment the en_US.UTF-8 line in /etc/locale.gen
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
# locale-gen generates locales for all uncommented locales in /etc/locale.gen
RUN locale-gen
ENV LANG=en_US.UTF-8

# install gcc
RUN \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 90 --slave /usr/bin/g++ g++ /usr/bin/g++-11

# git clone fuse into /home/user/FUSE
WORKDIR '/home/user'

RUN \
   git clone --recurse-submodules -j8 --config core.autocrlf=input https://github.com/encryptogroup/FUSE.git

RUN rm -rf /home/user/FUSE/extern/MOTION/extern/flatbuffers

RUN ldconfig

# modified files..
COPY CMakeLists.txt /home/user/FUSE

COPY benchmarks/CMakeLists.txt \
  /home/user/FUSE/benchmarks/CMakeLists.txt

# compilation fixes - required
COPY src/backend/CMakeLists.txt \
  /home/user/FUSE/src/backend/CMakeLists.txt

# adds developer directory... enables developer tutorial
COPY src/examples/CMakeLists.txt \
     /home/user/FUSE/src/examples/CMakeLists.txt

# enables verbose
COPY src/examples/developer/CMakeLists.txt \
     /home/user/FUSE/src/examples/developer/CMakeLists.txt

COPY src/examples/passes/CMakeLists.txt \
  /home/user/FUSE/src/examples/passes/CMakeLists.txt

COPY tests/CMakeLists.txt \
  /home/user/FUSE/tests/CMakeLists.txt

#flatbuffers are built by setup.py
#make flatbuffers
WORKDIR '/home/user/FUSE/extern/flatbuffers'
RUN \
  cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && \
  cmake -B build && \
  cmake --build build
#install flatbuffers
WORKDIR '/home/user/FUSE/extern/flatbuffers/build'
RUN \
  make install

# build
WORKDIR '/home/user/FUSE'
RUN \
  python3 setup.py --setup-build

# show what got built
RUN ls -lR /home/user/FUSE/build/bin/bm

# Define default command.
CMD ["bash"]
