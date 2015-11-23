==============
Best Practices
==============

The guidelines for developing in this repository are largely the same as the conventions for `Salt Formulas <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_ . It is therefore recommended to read these before familiarizing with the adaptions done here.

Structure
---------

The minimal directory structure must look like this::

    salt-states-base
    ├── ...
    ├── service
        ├── init.sls
        ├── map.jinja
        └── README.rst
    └── ...

:file:`salt-states-base/service/init.sls`:
    Basic service installation and _minimal_ configuration

:file:`salt-states-base/service/map.jinja`:
    This file contains platform-specific static data.

:file:`salt-states-base/service/README.rst`:
    Documentation of the service, including each sls file and configuration options.


Inline Documentation
--------------------

TODO

Extra Documentation
-------------------

TODO

Test scenarios
--------------

TODO
