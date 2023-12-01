ARG tag=latest
FROM ubuntu:${tag}

# see https://gitlab.jsc.fz-juelich.de/cstao-public/linktest
# in container, see /opt/linktest/exampleRun.sh
# mpirun --allow-run-as-root -N 2 linktest --mode mpi --num-warmup-messages 10 --num-messages 100 --size-messages $((16*1024*1024))
# to generate report:
# linktest-report -i pingpong_results_bin.sion -o report.pdf
# TODO: need a way to dump data to text file

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends \
        openssh-client openssh-server \
        locales \
        ca-certificates \
        curl \
        wget \
        apt-utils \
        clang \
        clang-format \
        openmpi-bin libopenmpi-dev \
        git \
        jq \
        python3-dev \
        python3-pip \
        build-essential \
        gcc-multilib \
        g++-multilib \
        python3-numpy \
        python3-matplotlib \
        libgtest-dev && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O test.tar.gz https://apps.fz-juelich.de/jsc/sionlib/download.php?version=1.7.7 && \
    tar -xzvg test.tar.gz && \
    cd sionlib && \
     ./configure --prefix=/usr --mpi=openmpi && \
     cd build-linux-gomp10-openmpi && \
     make && make install && \
    git clone https://gitlab.jsc.fz-juelich.de/cstao-public/linktest /opt/linktest && \
    git clone https://github.com/kraused/minipmi /opt/minipmi && \
    cd /opt/minipmi && make && make install && \
    cd /opt/linktest/benchmark && \
    make && make install && \
    cd /opt/linktest/python && \
    python3 setup.py install

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys
