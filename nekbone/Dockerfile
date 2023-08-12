ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich unzip bzip2

# install nekbone - this is where the scripts expect it
# To run any of these: mpiexec -np 2 ./nekbone
# example1 needs ftn and the install doesn't seem to work
WORKDIR /root
RUN git clone https://github.com/AMDComputeLibraries/Nekbone /root/nekbone-3.0 && \
    cd /root/nekbone-3.0/test/example2 && \
    ./makenek && \
    cd /root/nekbone-3.0/test/example3 && \
    ./makenek && \
    cd /root/nekbone-3.0/test/nek_comm && \
    ./makenek && \
    cd /root/nekbone-3.0/test/nek_delay && \
    ./makenek && \
    cd /root/nekbone-3.0/test/nek_mgrid && \
    ./makenek 

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
WORKDIR /root/nekbone-3.0/test
