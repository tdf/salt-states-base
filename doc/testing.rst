==============
Testing states
==============

Preparation
-----------

- Install `Docker <http://docker.io>`_
- On Debian Wheezy, you need to install the kernel from backports to be able to use docker.
- On Windows and MacOS, follow the Vagrant installation path and run the test from withing `vagrant ssh`.
- The directory structure must look like this::

    salt-pillar-base
    └── packages
    salt-states-base
    ├── ...
    └── test
        ├── build.sh
        ├── run.sh
	└── ...

Usage
-----

- Go to the directory :file:`test` in the `salt-states-base` distribution
- When running for the first time, please prepare the test containers::

    sudo ./build.sh

- Run the test suite::

    sudo ./run.sh

- This will do the following:
  
  - Download Debian 6, Debian 7, Centos 6, Ubuntu 12.04 Containers
  - Run a local highstate with all states enabled in each of them
