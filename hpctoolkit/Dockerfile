FROM asarkarparsys/llnl:gcc9_rajaperf_hpctoolkit 
# asarkarparsys/llnl:gcc9_rajaperf_hpctoolkit 
# We should likely provide this instead as a build here

# also see http://hpctoolkit.org/software-instructions.html
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

RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

