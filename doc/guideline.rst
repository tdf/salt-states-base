Documenting TDFs Infrastructure
-------------------------------

.. note::

	The service policy is currently a draft.


This document servers as the central guideline for documenting all services made available by The Document Foundation.

A service can fall into these categories:

Public Service
	A public service is available to the public without any general access restrictions. It helps people to get information about our products, download them and get help working with them, as well as communicate with others. Examples are the main website, wiki, AskLibO etc.

Internal Service
	An internal service is used to help running public services as well as secure them. Examples are Backup, Firewalling, Webserver, Databases.

Infrastructure Service
	Infrastructure services are used to run the above services and can range from bare metal machines, to KVM virtualization as well as our intranet core routers.


Every service also has one of the following priorities:

* Testing
* Low
* Middle
* High
* Mission-critical

Service Policy
^^^^^^^^^^^^^^

Services that are subject to the guidelines of this document are either running on a TDF owned IP, running on a TDF owned hostname and/or provide productive services for the TDF community.

It is our goal to make as much of our infrastructure setup public as possible, with the only exclusion being security considerations.
As of now, for a service going to be productive, it must at least fullfill the following requirements:

* At least two responsible people must know how to setup, configure and maintain a service. At least two independent ways of communication to these people must exist.
* The setup, configuration and regular maintenance tasks must be documented, with the not security related configuration being available in this repository.
* The documentation of the service must be kept up-to-date. If the documentation becomes out-of-date, the service may be regarded as no longer in production use.
* A backup plan for the service must be present.
* The necessary ports, IPs and other interdependencies must be documented.
* A desaster recovery plan must be created for the service.
* An optional requirement is to implement the setup, configuration and possibly maintenance as salt-states.


Adaption of the policy
^^^^^^^^^^^^^^^^^^^^^^

As soon as the service policy is put into place, the following actions will be performed:

* Identify the services currently provided by The Document Foundation
* Categorize them as public, internal or infrastructure
* Assess the priority of the service as low, middle, high and mission-critical
* Document the current adaption state of the service policy and steps needed to fully adapt the policy
* Provide a timeframe for the maintainers of the service to adapt the service policy
* If the service doesn't adopt the service policy in time, an extension might be granted up to the double of the timespan that was planned for the service to adopt the policy. If the priority of the service that fails to meet the adoption in time is middle or high, the Infrastructure Team will escalate the situation to the Board of Directors to ensure the appropriate resources are made available to ensure the full adaption of the service policy after the extension period.
* If the service still fails to adapt the policy after that time, depending on the priority of the service, the following actions might be taken, whereby actions for higher priorities also hold true for lower priority services:
  - Services of the priority *testing* might be taken offline without further notice if security or other  considerations justify the measure.
  - Services of the priorities *low* and *middle* will be moved to an environment with the following restrictions:
    > Available traffic and network speed might be limited
    > The usage of domains will be restricted to ones containing "-test" in the subdomain or domain, existing domains will be forwarded to the "-test" domain
    > The priority for the *availability* of the service is moved to *testing*
  - Services of the priorities *high* and *mission-critical* face no restriction regarding the environment. The situation is escalated to the Board of Directors to ensure that appropriate actions are taken. The Infrastructure Team might be unable to restore the service in case of errors.


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

Contributing
^^^^^^^^^^^^

* Fork the repository `tdf/salt-states-base`_.
* Clone the repository
* Do your changes to the documentation or states
* Test that the changes don't break anything, run ``make html``
* If you have changed salt-states, refer to :doc:`Testing </doc/states/testing>`
* Create a pull request

.. _tdf/salt-states-base: https://github.com/tdf/salt-states-base

