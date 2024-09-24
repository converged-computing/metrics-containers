FROM spack/ubuntu-jammy:latest AS builder

# docker build -t ghcr.io/converged-computing/metric-mpitrace:ubuntu-jammy .

# Usage (for testing)
# cd /opt/intel/mpi/2021.8.0/test
# mpicc -o test-program test.c
# export LD_PRELOAD=/opt/views/view/lib/libmpitrace.so
# mpirun --np 4 ./test-program
# unset LD_PRELOAD
# This will generate mpi_profiles!

# See https://github.com/IBM/mpitrace
RUN mkdir /opt/spack-environment \
&&  (echo spack: \
&&   echo '  specs: [binutils, papi, libiberty]' \
&&   echo '  view: /opt/views/view' \
&&   echo '  concretizer:' \
&&   echo '    unify: true' \
&&   echo '  packages:' \
&&   echo '    all:' \
&&   echo '      require: ["target=:x86_64"]' \
&&   echo '  config:' \
&&   echo '    install_tree: /opt/software') > /opt/spack-environment/spack.yaml

WORKDIR /opt
RUN apt-get update && apt-get install -y wget build-essential autoconf libtool libibverbs-dev librdmacm-dev && apt-get clean && \ 
    git clone -b v1.21.1 https://github.com/ofiwg/libfabric.git /opt/libfabric && \
    cd /opt/libfabric && ./autogen.sh && \
    ./configure --enable-efa=yes --enable-tcp=yes --enable-udp=yes --enable-sockets=yes --enable-verbs=yes --enable-shm=yes --enable-mrail=yes --enable-rxd=yes --enable-rxm=yes && \
    make -j 4 && make install

RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz && \
    tar -xzvf openmpi-4.1.2.tar.gz && \
    cd openmpi-4.1.2 && \
    ./configure --with-ofi=/usr/local && \
    make -j 4 && make install && ldconfig

# Install the software, remove unnecessary deps
RUN cd /opt/spack-environment && spack env activate . && spack install --fail-fast && spack gc -y

# Strip all the binaries
RUN find -L /opt/views/view/* -type f -exec readlink -f '{}' \; | \
    xargs file -i | \
    grep 'charset=binary' | \
    grep 'x-executable\|x-archive\|x-sharedlib' | \
    awk -F: '{print $1}' | xargs strip

# Modifications to the environment that are necessary to run
RUN cd /opt/spack-environment && \
    spack env activate --sh -d . > activate.sh

# Modifications to the environment that are necessary to run
RUN echo ". /opt/intel/mpi/latest/env/vars.sh" >> /etc/profile.d/z10_intel_environment.sh
WORKDIR /opt/

# Build mpitrace isolated to view
RUN cd /opt/spack-environment && \
    spack env activate . && \
    git clone https://github.com/IBM/mpitrace && \
    cd mpitrace/src && \
    LIBERTY_PATH=$(spack find --format "{prefix}" libiberty) && \
    PAPI_PATH=$(spack find --format "{prefix}" papi) && \
    BINUTILS_PATH=$(spack find --format "{prefix}" binutils) && \
    LD_LIBRARY_PATH=$LIBERTY_PATH/lib64 ./configure --with-vprof --with-binutils=${BINUTILS_PATH}:${LIBERTY_PATH}/lib64 && \
    make libmpitrace.so

# Note that I can't get papi to build -it is not happy with binutils
# testing for libbdf.a...libbfd.a not found ... check your binutils path ... exiting
# LD_LIBRARY_PATH=$LIBERTY_PATH/lib64 ./configure --with-vprof --with-papi=$PAPI_PATH/include --with-binutils=${BINUTILS_PATH}:${LIBERTY_PATH}/lib64 && \

# Move to the spack view
RUN cp /opt/spack-environment/mpitrace/src/libmpitrace.so /opt/views/view/lib/
    
# Bare OS image to run the installed executables
FROM rockylinux:8

COPY --from=builder /opt/spack-environment /opt/spack-environment
COPY --from=builder /opt/software /opt/software

# paths.view is a symlink, so copy the parent to avoid dereferencing and duplicating it
COPY --from=builder /opt/views /opt/views

RUN { \
      echo '#!/bin/sh' \
      && echo '.' /opt/spack-environment/activate.sh \
      && echo 'exec "$@"'; \
    } > /entrypoint.sh \
&& chmod a+x /entrypoint.sh \
&& ln -s /opt/views/view /opt/view

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
