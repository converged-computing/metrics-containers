ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive


# see https://asc.llnl.gov/sites/asc/files/2020-09/AMG_Summary_v1_7.pdf
RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich unzip bzip2

WORKDIR /opt
RUN git clone  https://github.com/LLNL/AMG.git && \
    cd ./AMG && \
    make

ENV PATH=/opt/AMG/test:$PATH

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
WORKDIR /opt/AMG
