#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
pushd docker/debian-7
docker build -t "salt-states-base/debian:7" .
popd
pushd docker/debian-6
docker build -t "salt-states-base/debian:6" .
popd