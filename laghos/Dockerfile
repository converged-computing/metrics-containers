ARG tag=latest
FROM ubuntu:${tag}

# cd /workflow/laghos 
# make tests

# This could probably be cleaned up - I added stuffs from
# the flux-mamba base.
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends \
        apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Utilities
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends \
        locales \
        ca-certificates \
        curl \
        wget \
        man \
        git \
        flex \
        ssh \
        sudo \
        vim \
        mpich \
        jq && \
    rm -rf /var/lib/apt/lists/*

# Compilers, autotools
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends \
        build-essential \
        pkg-config \
        autotools-dev \
        libtool \
	libffi-dev \
        autoconf \
        automake \
        make \
        cmake \
        clang \
        clang-tidy \
        gcc \
        g++ && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y libbz2-dev \
    liblzma-dev \
    libmpich-dev \
    libncurses5-dev && \
    rm -rf /var/lib/apt/lists/*

ENV MAKE_CXX_FLAG="MPICXX=mpic++"

# Wrappers to ensure we source the mamba environment!
WORKDIR /workflow

# Install hypre
RUN export hypre_options="--disable-fortran --enable-bigint" && \
    wget --no-verbose https://github.com/hypre-space/hypre/archive/v2.11.2.tar.gz && \
    tar -xzf v2.11.2.tar.gz && \
    mv hypre-2.11.2 hypre && \
    cd hypre/src && \
   ./configure ${hypre_options} CC=mpicc CXX=mpic++ && \
    make -j3

# Metis
RUN wget --no-verbose http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz && \
    tar -xzf metis-4.0.3.tar.gz && \
    mv metis-4.0.3 metis-4.0 && \
    make -j3 -C metis-4.0/Lib CC=mpicc OPTFLAGS="-Wno-error=implicit-function-declaration -O2"

RUN git clone --single-branch --depth 1 https://github.com/mfem/mfem && \
    unset LD_LIBRARY_PATH && \
    cd mfem && \
    make config MFEM_USE_MPI=YES MPICXX=mpiCC MFEM_MPI_NP=2 MFEM_DEBUG=${DEBUG} CPPFLAGS="${CPPFLAGS}" && \
    make
       
# And laghos! Laaaaggghhooooos sounds like lakes
RUN git clone --depth 1 https://github.com/CEED/Laghos laghos && \
    cd laghos && \ 
    make

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys
