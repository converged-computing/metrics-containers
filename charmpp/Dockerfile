ARG tag=latest
FROM ubuntu:${tag}

# docker build -t test .
# How to run a benchmark
# ./charmrun +p2 ./hello
# Note there are a TON of examples in here!

# This container is intended for testing the fusion fileystem as an application.
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc g++ \
    libtool \
    libreadline-dev \
    libevent-dev \
    libssl-dev \
    libtool \
    openssl \
    pkg-config \
    git \
    cmake \
    zlib1g-dev \
    wget

WORKDIR /opt
RUN wget --no-check-certificate https://charm.cs.illinois.edu/distrib/charm-latest.tar.gz && \
    tar xzf charm-latest.tar.gz && \
    rm charm-latest.tar.gz && \
    dirname=$(ls .) &&  \
    mv $dirname ./charm && \
    cd charm && \
    ./build charm++ netlrts-linux-x86_64 --with-production -j4

ENV PATH=/opt/charm/bin:$PATH

# Compile one exampel
RUN cd /opt/charm/examples/charm++/hello && \
    /opt/charm/bin/charmc hello.ci && \
    /opt/charm/bin/charmc hello.C -o hello
WORKDIR /opt/charm/examples

