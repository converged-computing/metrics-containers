FROM ubuntu:20.04

# docker build -t test .
# docker run -it test

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git wget g++ gcc build-essential \
    openssh-client openssh-server libgtk2.0-dev \
    net-tools hwloc libhwloc-dev libevent-dev gfortran libopenblas-dev \
    bc

# OpenMPI
WORKDIR /tmp
RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz && \
    tar xf openmpi-4.1.4.tar.gz && \
    cd openmpi-4.1.4 && \
    CFLAGS="-Ofast -march=native" ./configure --prefix=/opt/OpenMPI && \
    make && \
    make install

ENV MPI_HOME=/opt/OpenMPI
ENV PATH=$PATH:$MPI_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPI_HOME/lib

# OpenBLAS
RUN git clone https://github.com/xianyi/OpenBLAS.git && \
    cd OpenBLAS && \
    git checkout v0.3.21 && \
    make && \
    make PREFIX=/opt/OpenBLAS install

# Prepare tutorial per
# https://ulhpc-tutorials.readthedocs.io/en/latest/parallel/mpi/HPL

RUN git clone --depth 1 https://github.com/ULHPC/tutorials /opt/tutorials && \
    mkdir -p /opt/hpl && \
    cd /opt/hpl && \
    ln -s /opt/tutorials/parallel/mpi/HPL ref.d && \
    ln -s ref.d/Makefile . && \   
    mkdir src && \
    cd src && \
    export HPL_VERSION=2.3 && \
    wget --no-check-certificate http://www.netlib.org/benchmark/hpl/hpl-${HPL_VERSION}.tar.gz && \
    tar xvzf hpl-${HPL_VERSION}.tar.gz && \
    mv hpl-${HPL_VERSION} ~/hpl

WORKDIR /root/hpl
COPY Makefile ./Make.linux
RUN make arch=linux && \
    make arch=linux install
    
ENV PATH=/root/hpl/bin/linux:$PATH


# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys
