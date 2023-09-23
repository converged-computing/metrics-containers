ARG tag="8"
FROM rockylinux:${tag} as builder

ENV DEBIAN_FRONTEND=noninteractive

#  Enable PowerTools for development packages
RUN yum -y update \
 && dnf -y install 'dnf-command(config-manager)' \
 && yum config-manager --set-enabled powertools \
 && yum -y update \
 && yum -y install epel-release \
 && yum -y install \
	wget \
        fftw-devel \
        fftw \
	git \
	curl \
	bind-utils \
	sudo \
	jq \
	which \
	file \
	unzip \
	vim \
	patch \
	diffutils \
	pkgconfig \
	libtool \
	autoconf \
	automake \
	gcc-gfortran \
	gcc \
	gcc-c++ \
	make \
	cmake \
	bison \	
	flex \
	python3-devel \
        fftw3-devel fftw3 \
        openssh-server \
        openssh-clients \
 && yum clean all

#  Set default /usr/bin/python to python3
RUN alternatives --set python /usr/bin/python3

ENV LANG=C.UTF-8
RUN printf "LANG=C.UTF-8" > /etc/locale.conf

RUN git clone https://github.com/GoogleCloudPlatform/hpc-tools && \
    yum group install -y "Development tools" && \
    cd hpc-tools/rocky_linux_8 && \
    chmod +x google_install_intelmpi google_hpc_libfabric && \
    # installs to /opt/intel
    ./google_install_intelmpi --impi_2021 && \
    # And install libfabric with net/psm3 
    ./google_hpc_libfabric --net --psm3
    

# Modifications to the environment that are necessary to run
RUN echo ". /opt/intel/mpi/latest/env/vars.sh" >> /etc/profile.d/z10_intel_environment.sh
WORKDIR /opt/

# install laamps alongside spack
RUN . /opt/intel/mpi/latest/env/vars.sh  && \
    git clone --depth 1 --branch stable_29Sep2021_update2 https://github.com/lammps/lammps.git /opt/lammps && \
    cd /opt/lammps && \
    mkdir build && \
    cd build && \
    . /etc/profile && \ 
    cmake ../cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DPKG_REAXFF=yes -DBUILD_MPI=yes -DPKG_OPT=yes -DFFT=FFTW3 -DCMAKE_PREFIX_PATH=/opt/intel/mpi/2021.8.0 -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu && \
    make && \
    make install

# sshd
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '';

WORKDIR /opt/lammps/examples/reaxff/HNS
  
# Hack for ssh for now...
RUN echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    cd /root && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
