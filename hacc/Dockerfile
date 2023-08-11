ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive

## IMPORTANT: this is built for powerPC and we don't currently run it.

RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich unzip bzip2

# Run command is usually:
# see https://asc.llnl.gov/sites/asc/files/2020-09/coral-hacc-benchmark-summary-v1.7.pdf
# hacc_tpm indat cmbM000.tf m000 INIT ALL_TO_ALL -w -R -N 512 -t GEOMETRY
# Geometry example for small: np = ng = 160, physical box = 126, -t 1x1x1
# hacc_tpm indat cmbM000.tf m000 INIT ALL_TO_ALL -w -R -N 512 -t np = ng = 160, physical box = 126, -t 1x1x1

# install hacc
WORKDIR /opt/
RUN wget https://asc.llnl.gov/sites/asc/files/2020-09/HACC_1_7.zip && \
    unzip HACC_1_7.zip && \
    rm -rf __MACOSX/ && \
    bzip2 -d HACC_1_7.tar.bz2 && \
    tar -xvf HACC_1_7.tar   

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
WORKDIR /opt/HACC_1_7
