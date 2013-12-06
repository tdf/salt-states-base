==============
Testing states
==============

Preparation
-----------

- Install `Docker <http://docker.io>`
- On Debian Wheezy, you need to install the kernel from backports to be able to use docker

Usage
-----

- Go to the directory :file:`test` in the `salt-states-base` distribution
- Run the test suite::

    sudo ./run.sh

- This will do the following:
  
  - Download Debian 6, Debian 7, Centos 6, Ubuntu 12.04 Containers
  - Run a local highstate with all states enabled in each of them
