FROM spack/ubuntu-jammy:latest as builder

RUN mkdir /opt/spack-environment \
&&  (echo spack: \
&&   echo '  specs:'  \
&&   echo '    - hpl'  \
&&   echo '    - intel-oneapi-mkl'  \
&&   echo '  view: /opt/views/view' \
&&   echo '  concretizer:' \
&&   echo '    unify: true' \
&&   echo '  packages:' \
&&   echo '    all:' \
&&   echo '      require: ["target=:x86_64"]' \
&&   echo '  config:' \
&&   echo '    install_tree: /opt/software') > /opt/spack-environment/spack.yaml

# Install the software, remove unnecessary deps
RUN cd /opt/spack-environment && spack env activate . && spack install --fail-fast && spack gc -y

# Strip all the binaries
RUN find -L /opt/views/view/* -type f -exec readlink -f '{}' \; | \
    xargs file -i | \
    grep 'charset=binary' | \
    grep 'x-executable\|x-archive\|x-sharedlib' | \
    awk -F: '{print $1}' | xargs strip

# Modifications to the environment that are necessary to run
RUN cd /opt/spack-environment && \
    spack env activate --sh -d . > activate.sh

# Bare OS image to run the installed executables
FROM ubuntu:22.04
COPY --from=builder /opt/spack-environment /opt/spack-environment
COPY --from=builder /opt/software /opt/software

# paths.view is a symlink, so copy the parent to avoid dereferencing and duplicating it
COPY --from=builder /opt/views /opt/views

RUN { \
      echo '#!/bin/sh' \
      && echo '.' /opt/spack-environment/activate.sh \
      && echo 'exec "$@"'; \
    } > /entrypoint.sh \
&& chmod a+x /entrypoint.sh \
&& ln -s /opt/views/view /opt/view

RUN apt-get update && \
    apt-get install -y \
        wget bc \
        openssh-client openssh-server && \
        apt-get clean

RUN wget -O /opt/view/bin/compute_N https://raw.githubusercontent.com/ULHPC/tutorials/6715c683f851afd61b5a58461863d92bd39df039/parallel/mpi/HPL/scripts/compute_N && \
    chmod +x /opt/view/bin/compute_N

# This will ensure spack is loaded with ssh
RUN mkdir -p /root/.ssh && cat /etc/environment /opt/spack-environment/activate.sh > /etc/environment

# Hack for ssh for now...
# This allows us to use ~/.ssh/environment
RUN echo "    LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    mkdir -p /run/sshd && \
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && chmod og+rX . && \
    cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys

EXPOSE 22
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
