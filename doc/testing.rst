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

  This will download Debian 6, Debian 7, CentOS 6 and Ubuntu 12.04 containers and install and configure a masterless salt in them.

- Run the test suite::

    sudo ./run.sh

  This runs a local highstate with all states enabled in each of the containers. The output can be found in the directory :file:`test/log`.

- It is also possible to run own commands in the test suite. For example, if you want to test a specific state::

    sudo ./run.sh state.sls my.state


Notes
-----

The command :program:`run.sh` is designed to make sure that every time it is called, a fresh container is used.
