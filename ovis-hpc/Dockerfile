ARG tag=latest
FROM ubuntu:${tag}

# docker build -t test .
# docker run -itd --name test test 
# docker exec -it test bash

# Without -a munge because we've disabled auth
# ldms_ls -h localhost -x sock -p 10444
# ldms_ls -h localhost -x sock -p 10444 -v
# ldms_ls -h localhost -x sock -p 10444​ -l
# ldms_ls -h localhost -x sock -p 10444​ -l -v


# This container is intended for testing the fusion fileystem as an application.
RUN apt-get update && apt-get install -y \
    autoconf \
    autogen \
    bison \
    build-essential \
    doxygen \
    gcc g++ \
    flex \ 
    gettext \
    libtool \
    libreadline-dev \
    libevent-dev \
    libssl-dev \
    libtool \
    openssl \
    pkg-config \
    swig \
    systemctl \
    python3-yaml \
    python3 \
    python3-dev \
    libglib2.0-dev \
    git \
    munge

WORKDIR /opt
RUN git clone https://github.com/ovis-hpc/ovis && \
    cd ovis && \
    ./autogen.sh && \
    ./configure --prefix=/usr && make && make install

ENV LDMSD_PLUGIN_LIBPATH=/usr/lib/ovis-ldms
ENV ZAP_LIBPATH=/usr/lib/ovis-ldms
ENV COMPONENT_ID=1
ENV SAMPLE_INTERVAL=1000000
ENV SAMPLE_OFFSET=50000
COPY ./sampler.conf /opt/sampler.conf

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
