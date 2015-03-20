#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
set -e
docker build -t "salt_states_base/debian:7" docker/debian-7
docker build -t "salt_states_base/ubuntu:12.04" docker/ubuntu-12.04
docker build -t "salt_states_base/ubuntu:14.04" docker/ubuntu-14.04
docker build -t "salt_states_base/centos:6" docker/centos-6
docker build -t "salt_states_base/centos:7" docker/centos-7
