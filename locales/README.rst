=======
Locales
=======

Module to configure locales and keyboard settings

init
----

Installs the `locales` package as well as the manpages and language packs associated with the selected language. The locales are generated using `locale-gen`.

The keyboard layout associated with the selected language is set in :file:`/etc/default/keyboard`, as an example the german one:

.. literalinclude:: de.keyboard.debian
   :linenos:

Pillar
------

.. code-block:: yaml

    lang: de
