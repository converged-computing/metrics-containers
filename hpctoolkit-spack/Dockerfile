FROM ubuntu

# see http://hpctoolkit.org/software-instructions.html
RUN apt-get update && apt-get install -y \
    openssh-client openssh-server \
    git \
    file \
    build-essential \
    gfortran \
    bzip2 \
    g++ gcc \
    diffutils \
    python3-dev \
    curl \
    wget
    
RUN git clone --depth 1 https://github.com/spack/spack.git && \
    git clone https://gitlab.com/hpctoolkit/hpctoolkit.git && \
    cp hpctoolkit/spack/packages.yaml spack/etc/spack/

ENV PATH=/spack/bin:$PATH
RUN spack config update packages -y && \
    spack compiler find
COPY ./compilers.yaml /root/.spack/linux/compilers.yaml
RUN spack install hpctoolkit

RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys
