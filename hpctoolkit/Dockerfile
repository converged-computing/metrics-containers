FROM ubuntu

# see http://hpctoolkit.org/software-instructions.html
RUN apt-get update && apt-get install -y \
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
    git clone https://gitlab.com/hpctoolkit/hpctoolkit.git

# RUN cp hpctoolkit/spack/packages.yaml spack/etc/spack/

ENV PATH=/spack/bin:$PATH
RUN spack external find && \
    spack compiler find
COPY ./compilers.yaml /root/.spack/linux/compilers.yaml
RUN spack install hpctoolkit
