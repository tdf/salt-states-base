#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set +e
STATEPATH=$(readlink -e ..)
PILLARPATH=$(readlink -e ../../salt-pillar-base)
COMMAND=${*:-state.highstate}
docker run -rm=true -v $STATEPATH:/srv/salt:ro -v $PILLARPATH:/srv/pillar:ro salt-states-base/debian:7 salt-call $COMMAND 2>/dev/null | tee log/debian-7.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro -v $PILLARPATH:/srv/pillar:ro salt-states-base/debian:6 salt-call $COMMAND 2>/dev/null | tee log/debian-6.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro -v $PILLARPATH:/srv/pillar:ro salt-states-base/centos:6 salt-call $COMMAND 2>/dev/null | tee log/centos-6.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro -v $PILLARPATH:/srv/pillar:ro salt-states-base/ubuntu:12.04 salt-call $COMMAND 2>/dev/null | tee log/ubuntu-12.04.log
