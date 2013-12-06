#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set -e
pushd docker/debian-7
docker build -t "salt-states-base/debian:7" .
popd
pushd docker/debian-6
docker build -t "salt-states-base/debian:6" .
popd
pushd docker/ubuntu-12.04
docker build -t "salt-states-base/ubuntu:12.04" .
popd
pushd docker/centos-6
docker build -t "salt-states-base/centos:6" .
popd
set +e
STATEPATH=$(readlink -e state)
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/debian:7 salt-call state.highstate -l debug | tee log/debian-7.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/debian:6 salt-call state.highstate -l debug | tee log/debian-6.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/centos:6 salt-call state.highstate -l debug | tee log/centos-6.log
docker run -rm=true -v $STATEPATH:/srv/salt:ro salt-states-base/ubuntu:12.04 salt-call state.highstate -l debug | tee log/ubuntu-12.04.log