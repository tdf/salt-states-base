#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set +e
STATEPATH=$(readlink -e ..)
COMMAND=${*:-state.highstate}
LOGCOMMAND=${COMMAND// /_}
DISTROS=(debian:7 debian:8 centos:7 ubuntu:12.04 ubuntu:14.04)
for DISTRO in ${DISTROS[*]}; do
    echo "Running $COMMAND on $DISTRO"
    mkdir -p log/$DISTRO/
    docker run --rm=true -v $STATEPATH:/srv/salt:ro salt_states_base/$DISTRO salt-call $COMMAND 2> log/$DISTRO/$LOGCOMMAND.out > log/$DISTRO/$LOGCOMMAND.err &
done
wait
