FROM ubuntu

# docker build -t ghcr.io/converged-computing/metric-sysstat .
# The entrypoint to download the pid wait command will be generated on the fly
# via a config map

RUN apt-get update && apt-get install -y git g++ build-essential python3-pip wget psmisc
RUN git clone https://github.com/sysstat/sysstat /opt/sysstat && \
    cd /opt/sysstat && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    pip3 install jc
