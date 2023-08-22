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
    curl
    
RUN git clone --depth 1 https://github.com/spack/spack.git && \
    git clone https://gitlab.com/hpctoolkit/hpctoolkit.git

# RUN cp hpctoolkit/spack/packages.yaml spack/etc/spack/

ENV PATH=/spack/bin:$PATH
RUN spack external find && \
    spack compiler find
COPY ./compilers.yaml /root/.spack/linux/compilers.yaml
RUN spack install hpctoolkit

# HOME=/pdc/vol/hpctoolkit/src/pseudohome spack install hpctoolkit +cray
# HOME=/pdc/vol/hpctoolkit/src/pseudohome srun -n 1 spack install hpctoolkit +cray

# cd hpctoolkit-242f100

# export CC=cc
# export MPICC=cc
# export CXX=CC
# export MPICXX=CC
# export F77=ftn
# export MPIF77=ftn

#./configure \
#    --prefix=/pdc/vol/hpctoolkit/242f100 \
#    --with-binutils=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/binutils-2.33.1-cyyyok2rjhfuko33vvttdez6y7ir6owm \
#    --with-boost=/pdc/vol/boost/1.63.0-gcc-8.3.0 \
#    --with-bzip=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/bzip2-1.0.8-5765gchztrj6huzzmx3ktwkhqimqgbm6 \
#    --with-dyninst=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/dyninst-10.1.0-jh5y6zezzri44ivmlpivjpfv7er6izbk \
#    --with-elfutils=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/elfutils-0.178-px6sderbjj6u57okr34dndrujlpj4vca \
#    --with-tbb=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/intel-tbb-2020.1-wrxfw5ipcjh2emong64shgigdzvlxakl \
#    --with-libdwarf=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/libdwarf-20180129-ezxzqxlqnndxfc7zdjiezzhoelnwpjek \
#    --with-libmonitor=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/libmonitor-2018.07.18-47ywgsuobliskk3m5kuh76bujz2gy77o \
#    --with-libunwind=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/libunwind-1.4-rc1-64h2x4eupsgcwghop7xh44rp25qt4vsv \
#    --with-mbedtls=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/mbedtls-2.16.1-zrzwxwt6t5r3srjjr3wnvthljn2qllen \
#    --with-xerces=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/xerces-c-3.2.2-l4rwy2gy5s7b4ywhzx53c3eooltg36pd \
#    --with-lzma=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/xz-5.2.4-bqxfvbp2on5cntdlwllmtasfxpzxghly \
#    --with-zlib=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/zlib-1.2.11-opn2xungd3hfytvpnj5h6yt6bandexht \
#    --with-xed=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/intel-xed-2019.03.01-qmuu5jzb6xcz6loakd6eztlfcl7xh5jt \
#    --with-perfmon=/pdc/vol/hpctoolkit/src/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/libpfm4-4.10.1-x2lknu3nav2l3rvvbqsrz7czscl2eztr \
#    --enable-all-static MPICXX=CC

#make -j 4 | tee m.log
#make install

#export PATH=$PATH:/pdc/vol/hpctoolkit/242f100/bin
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/pdc/vol/hpctoolkit/242f100/lib/hpctoolkit
