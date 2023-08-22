FROM ubuntu
RUN apt-get update && apt-get install -y python3-pip python3-dev git \
    openssh-client openssh-server
RUN git clone https://github.com/GoogleCloudPlatform/PerfKitBenchmarker
WORKDIR /PerfKitBenchmarker
RUN pip3 install -r /PerfKitBenchmarker/requirements.txt && \
    pip3 install .
    
# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys
