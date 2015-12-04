#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set +e
STATEPATH=$(readlink -e ..)
DISTRO=$1
shift
COMMAND=${*:-state.highstate}
docker build -q -t "salt_states_base/$DISTRO" docker/$DISTRO
echo "Running $COMMAND on $DISTRO"
docker run --rm=true -v $STATEPATH:/srv/salt:ro salt_states_base/$DISTRO salt-call $COMMAND --local --retcode-passthrough -l warning --force-color
exit $?