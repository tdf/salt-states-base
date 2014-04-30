=======
Package
=======

This is a collection of various states that intall miscellaneous packages.

Available pillar settings
-------------------------

To adapt the installed packages, define your pillar data as such:

.. code-block:: yaml

  package:
    lookup:
      <core>:
        - bash-completion
        - debconf-utils
        - dstat
        - ...

Available states
----------------

core
^^^^

Installs core packages.

drbd
^^^^

Installs drbd packages.

extra
^^^^^

Installs extra packages.

git
^^^

Installs packages for git.


lxc
^^^

Installs packages for lxc.


net
^^^

Installs networking packages.


pacemaker
^^^^^^^^^

Installs packages for pacemaker.


upgrades
^^^^^^^^

Installs the `unattended-upgrades` packages and configures it with this debconf:

.. literalinclude:: upgrades.debconf
   :linenos:


zsh
^^^

Installs packages needed for a basic zsh installation.

init
^^^^

Includes core, git and net
