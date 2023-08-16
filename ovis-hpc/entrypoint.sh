#!/bin/bash

# Setup munge
mkdir -p /run/munge
chown -R 0 /var/log/munge /var/lib/munge /etc/munge /run/munge


# Skip munge for now, not on a cluster
# ldmsd -x sock:10444 -c /opt/sampler.conf -l /tmp/demo_ldmsd_log -v DEBUG -a munge  -r $(pwd)/ldmsd.pid
ldmsd -x sock:10444 -c /opt/sampler.conf -l /tmp/demo_ldmsd_log -v DEBUG -r $(pwd)/ldmsd.pid
sleep infinity
