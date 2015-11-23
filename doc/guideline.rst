Documenting TDFs Infrastructure
-------------------------------

This document servers as the central guideline for documenting all publicly accessible services made available by The Document Foundation.

It is our goal to make as much of our infrastructure setup public as possible, with the only exclusion being security considerations.
As of now, for a service going to be productive, it must at least fullfill the following requirements:

* At least two members of TDF must know how to setup, configure and maintain a service
* The setup, configuration and regular maintenance tasks must be documented, with the not security related configuration being available in this repository
* The documentation of the service must be kept up-to-date. If the documentation becomes out-of-date, the service may be regarded as no longer in production use.
* An optional requirement is to implement the setup, configuration and possibly maintenance as salt-states.



About this documentation
^^^^^^^^^^^^^^^^^^^^^^^^

This documentation uses the reStructuredText-Syntax. For more information please see `rst documentation`_ and `sphinx`_.

This documentation can be converted into a variety of formats. To do this, you need to install the python-package sphinx.

To install sphinx under **OSX** and **Linux**::

  sudo pip install sphinx

To install sphinx under **Windows**::

  easy_install sphinx

Under **Windows** please make sure that the script-path of your Python-Installation is in ``PATH``.

.. _rst documentation: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
.. _sphinx: http://sphinx-doc.org/

Building
^^^^^^^^

* **OSX** and **Linux** in the directory containing the :file:`Makefile`::

    make html

* **Windows** in the directory containting the :file:`make.bat`::

    make.bat html

* To build a single large HTML-File, exchange ``html`` for ``singlehtml``
* To build an epub, exchange ``html`` for ``epub``
* To build latex/PDF, exchange ``html`` for ``latex``/``latexpdf``
* To build plaintext, exchange ``html`` for ``text``


