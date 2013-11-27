=======
Package
=======

This is a collection of various states that intall miscellaneous packages.

core
----

Installs core packages. The list of packages is defined as such:

.. code-block:: yaml

  packages_core:
    - bash-completion
    - debconf-utils
    - dstat
    - ...

drbd
----

Installs drbd packages. The list of packages is defined as such:

.. code-block:: yaml

  packages_drbd:
    - drbd8-utils
    - ...

extra
-----

Installs extra packages. The list of packages is defined as such:

.. code-block:: yaml

  packages_extra:
    - package1
    - package2
    - ...

git
---

Installs packages for git. The list of packages is defined as such:

.. code-block:: yaml

  packages_git:
    - package1
    - package2
    - ...


lxc
---

Installs packages for lxc. The list of packages is defined as such:

.. code-block:: yaml

  packages_lxc:
    - package1
    - package2
    - ...


net
---

Installs networking packages. The list of packages is defined as such:

.. code-block:: yaml

  packages_net:
    - package1
    - package2
    - ...


pacemaker
---------

Installs packages for pacemaker. The list of packages is defined as such:

.. code-block:: yaml

  packages_pacemaker:
    - package1
    - package2
    - ...


upgrades
--------

Installs the `unattended-upgrades` packages and configures it with this debconf:

.. literalinclude:: upgrades.debconf
   :linenos:


zsh
---

Installs packages needed for a basic zsh installation. The list of packages is defined as such:

.. code-block:: yaml

  packages_zsh:
    - package1
    - package2
    - ...

init
----

Includes core, git and net
