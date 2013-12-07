#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set +e
STATEPATH=$(readlink -e state)
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/debian:7 salt-call state.highstate -l debug | tee log/debian-7.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/debian:6 salt-call state.highstate -l debug | tee log/debian-6.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/centos:6 salt-call state.highstate -l debug | tee log/centos-6.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/ubuntu:12.04 salt-call state.highstate -l debug | tee log/ubuntu-12.04.log
