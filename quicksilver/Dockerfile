ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive

# Example command
# qs /opt/quicksilver/Examples/CORAL2_Benchmark/Problem1/Coral2_P1.inp

# All examples:
# /opt/quicksilver/Examples/AllScattering/scatteringOnly.inp
# /opt/quicksilver/Examples/NoCollisions/no.collisions.inp
# /opt/quicksilver/Examples/NonFlatXC/NonFlatXC.inp
# /opt/quicksilver/Examples/CORAL2_Benchmark/Problem2/Coral2_P2_4096.inp
# /opt/quicksilver/Examples/CORAL2_Benchmark/Problem2/Coral2_P2.inp
# /opt/quicksilver/Examples/CORAL2_Benchmark/Problem2/Coral2_P2_1.inp
# /opt/quicksilver/Examples/CORAL2_Benchmark/Problem1/Coral2_P1.inp
# /opt/quicksilver/Examples/CORAL2_Benchmark/Problem1/Coral2_P1_1.inp
# /opt/quicksilver/Examples/CORAL2_Benchmark/Problem1/Coral2_P1_4096.inp
# /opt/quicksilver/Examples/CTS2_Benchmark/CTS2.inp
# /opt/quicksilver/Examples/CTS2_Benchmark/CTS2_36.inp
# /opt/quicksilver/Examples/CTS2_Benchmark/CTS2_1.inp
# /opt/quicksilver/Examples/AllAbsorb/allAbsorb.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem_v4_ts.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem_v5_ts.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem_v3_wq.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem_v7_ts.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem_v4_tm.inp
# /opt/quicksilver/Examples/Homogeneous/homogeneousProblem_v3.inp
# /opt/quicksilver/Examples/AllEscape/allEscape.inp
# /opt/quicksilver/Examples/NoFission/noFission.inp

# see https://asc.llnl.gov/sites/asc/files/2020-09/AMG_Summary_v1_7.pdf
RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich unzip bzip2

WORKDIR /opt
RUN git clone https://github.com/LLNL/Quicksilver quicksilver
COPY ./Makefile /opt/quicksilver/src/Makefile
WORKDIR /opt/quicksilver/src
RUN make && mv qs /usr/bin/qs

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
WORKDIR /opt/quicksilver/Examples
