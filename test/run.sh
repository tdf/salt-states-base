#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set +e
STATEPATH=$(readlink -e ..)
PILLARPATH=$(readlink -e ../../salt-pillar-base)
COMMAND=${*:-state.highstate}
LOGCOMMAND=${COMMAND// /_}
DISTROS=(debian:7 centos:6 centos:7 ubuntu:12.04 ubuntu:14.04)
for DISTRO in ${DISTROS[*]}; do
    echo "Running $COMMAND on $DISTRO"
    mkdir -p log/$DISTRO/
    docker run --rm=true -v $STATEPATH:/srv/salt:ro -v $PILLARPATH:/srv/pillar:ro salt_states_base/$DISTRO salt-call $COMMAND 2> log/$DISTRO/$LOGCOMMAND.out > log/$DISTRO/$LOGCOMMAND.err &
done
wait
