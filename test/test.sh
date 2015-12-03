#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
./build.sh
shopt -s nullglob
pushd ..
states=([^_]*/)
popd
delete=(doc/)
states=( "${states[@]/$delete}" )
delete=(test/)
states=( "${states[@]/$delete}" )
RETCODE=0
for state in "${states[@]}"
do
    ./run.sh state.show_sls ${state%/} || RETCODE=1
done

for state in "${states[@]}"
do
    ./run.sh state.sls ${state%/} || RETCODE=1
done
exit $RETCODE