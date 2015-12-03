=======
Console
=======


These states manage console-settings.

init
----

The init.sls includes other platform-specific sls.

debian
------

debian.sls manages console-settings, includes console-setup to set up console and configures it using the following debconf:

.. literalinclude:: console-setup
   :linenos:
