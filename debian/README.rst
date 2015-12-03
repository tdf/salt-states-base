======
Debian
======


These states manage debian-specific settings.

backports
---------

Enables backports in :file:`/etc/apt/sources.list.d/backports.list` with one of the following files:

.. literalinclude:: sources.list.debian.wheezy.backports
   :linenos:


debconf
-------

.. deprecated:: 0.0
  The package `debconf-utils` is now always included in the requisites

sources
-------

Updates the file :file:`/etc/apt/sources.list` with one of the following files:

.. literalinclude:: sources.list.debian.squeeze
   :linenos:

.. literalinclude:: sources.list.debian.wheezy
   :linenos:

.. literalinclude:: sources.list.ubuntu.precise
   :linenos:

.. literalinclude:: sources.list.ubuntu.quantal
   :linenos:


init
----

The init.sls includes sources and debconf.
