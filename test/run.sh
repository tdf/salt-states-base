#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set +e
STATEPATH=$(readlink -e ..)
CONFPATH=$(readlink -e ./conf/)

if [ -z "$1" -o "$1" = "--help" ] ; then
    echo "Syntax ./run.sh <DISTRO>"
    echo "Missing argument DISTRO"
    echo "Supported DISTRO are:"
    ls -1 docker/
    exit 1
fi

DISTRO=$1
shift
COMMAND=${*:-state.highstate}
docker build -q -t "salt_states_base/$DISTRO" docker/$DISTRO
echo "Running $COMMAND on $DISTRO"
docker run --rm=true -v $STATEPATH:/srv/salt:ro -v $CONFPATH:/etc/salt/minion.d:ro salt_states_base/$DISTRO salt-call $COMMAND --local -l warning --force-color | tee /tmp/$$.log
grep -q "\[01\?;31m" /tmp/$$.log
RETCODE=$?
if [ $RETCODE -eq 1 ]; then
   exit 0
fi
exit 1
