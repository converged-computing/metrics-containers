ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive

# How to run (system trace)
# out/linux/tracebox -o trace_file.perfetto-trace --txt -c test/configs/scheduling.cfg
# open in https://ui.perfetto.dev/

RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich unzip bzip2 curl

WORKDIR /opt
RUN git clone https://android.googlesource.com/platform/external/perfetto/ && \
    cd perfetto && \
    ./tools/install-build-deps && \
    ./tools/gn gen --args='is_debug=false' out/linux  && \
    ./tools/ninja -C out/linux tracebox traced traced_probes perfetto 
ENV PATH=/opt/perfetto/tools/out/linux:$PATH

# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
WORKDIR /opt/perfetto/tools
