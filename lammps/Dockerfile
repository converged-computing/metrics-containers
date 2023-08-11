ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich

# install laamps
WORKDIR /opt/
RUN git clone --depth 1 --branch stable_29Sep2021_update2 https://github.com/lammps/lammps.git /opt/lammps && \
    cd /opt/lammps && \
    mkdir build && \
    cd build && \
    . /etc/profile && \ 
    cmake ../cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DPKG_REAXFF=yes -DBUILD_MPI=yes -DPKG_OPT=yes -DFFT=FFTW3 -DCMAKE_PREFIX_PATH=/usr/lib/mpich -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu && \
    make && \
    make install

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
WORKDIR /opt/lammps/examples/reaxff/HNS

