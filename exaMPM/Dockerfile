ARG tag=latest
FROM ubuntu:${tag}

# see run details: https://github.com/ECP-copa/ExaMPM/wiki/Run

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends \
        openssh-client openssh-server \
        locales \
        ca-certificates \
        curl \
        wget \
        libhdf5-serial-dev \
        libhdf5-mpi-dev  \
        apt-utils \
        cmake \
        clang \
        clang-format \
        doxygen \
        openmpi-bin libopenmpi-dev \
        git \
        jq \
        build-essential \
        python3-pip \
        unzip \
        libgtest-dev && \
    rm -rf /var/lib/apt/lists/*

ENV KOKKOS_SRC_DIR=/opt/kokkos
ENV KOKKOS_INSTALL_DIR=$KOKKOS_SRC_DIR/build/install
ENV MAKE_CXX_FLAG="MPICXX=mpic++"

RUN python3 -m pip install clang-format
RUN git clone https://github.com/kokkos/kokkos.git /opt/kokkos && \
    cd /opt/kokkos && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE="Release" \
      -D CMAKE_INSTALL_PREFIX=$KOKKOS_INSTALL_DIR \
      -D Kokkos_ENABLE_OPENMP=ON \
      -D Kokkos_ENABLE_SERIAL=ON .. && \
      make install

ENV CABANA_INSTALL_DIR=/opt/Cabana/build/install
RUN wget https://github.com/ECP-copa/Cabana/archive/refs/tags/0.6.1.zip && \
    unzip 0.6.1.zip && \
    mv Cabana-0.6.1/ /opt/Cabana && \
    cd /opt/Cabana && \
    mkdir build && cd build && \
    cmake \
      -D CMAKE_BUILD_TYPE="Release" \
      -D CMAKE_PREFIX_PATH=$KOKKOS_INSTALL_DIR \
      -D CMAKE_INSTALL_PREFIX="$CABANA_INSTALL_DIR" \
      -D Cabana_REQUIRE_OPENMP=ON \
      -D Cabana_ENABLE_EXAMPLES=ON \
      -D Cabana_ENABLE_TESTING=ON \
      -D Cabana_REQUIRE_HDF5=ON \
      -D Cabana_ENABLE_PERFORMANCE_TESTING=OFF \
      -D Cabana_ENABLE_CAJITA=ON .. && \
    make install 
 
# Install exaMPM
RUN git clone https://github.com/ECP-copa/ExaMPM /opt/exaMPM && \
    cd /opt/exaMPM && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE="Release" \
      -D CMAKE_PREFIX_PATH=$CABANA_INSTALL_DIR \
      -D CMAKE_INSTALL_PREFIX=install .. && \
    make install

WORKDIR /opt/exaMPM/build/examples

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys
