#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
./build.sh
shopt -s nullglob
states=([^_]*/)
delete=(doc/)
states=( "${states[@]/$delete}" )
delete=(test/)
states=( "${states[@]/$delete}" )
for state in "${states[@]}"
do
    ./run.sls state.show_sls ${state%/}
done

for state in "${states[@]}"
do
    ./run.sls state.sls ${state%/}
done