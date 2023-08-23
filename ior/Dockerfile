ARG tag=latest
FROM ubuntu:${tag}
ENV DEBIAN_FRONTEND=noninteractive

# Example command
# pennant /opt/pennant/test/sedovsmall/sedovsmall.pnt 

RUN apt-get update && \
    apt-get install -y fftw3-dev fftw3 pdsh libfabric-dev libfabric1 \
        openssh-client openssh-server \
        dnsutils telnet strace cmake git g++ \
        mpich unzip bzip2 pkg-config \
        libhdf5-serial-dev \
        gfarm-client m4 libgfarm-dev libs3-dev \
        libcurl4-gnutls-dev libxml2  libssl-dev \
        libpmem-dev libcephfs-dev

RUN git clone https://github.com/mar-file-system/aws4c /opt/aws4c && \
    wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz && \
    tar xzvf pnetcdf-1.12.3.tar.gz && \
    cd pnetcdf-1.12.3 && \
    ./configure --prefix=/usr && \
    make && \
    make install

WORKDIR /opt
RUN wget https://github.com/hpc/ior/releases/download/4.0.0rc1/ior-4.0.0rc1.tar.gz && \
    tar -xzvf ior-4.0.0rc1.tar.gz && \
    rm ior-4.0.0rc1.tar.gz && \
    mv ior-4.0.0rc1 ./ior

# Note I did as many as I quickly could here - would be good to add aws
WORKDIR /opt/ior
RUN ./configure --prefix=/usr \
      --with-ncmpi --with-pmdk  \
      --with-cephfs --with-daos --with-gfarm  && \
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
