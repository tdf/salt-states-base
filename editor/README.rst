======
Editor
======

These states manage the installation and configuration of editors

vim
---

Installs the package `vim` and configures it using the following file :file:`/etc/vim/vimrc`:

.. literalinclude:: vimrc
   :language: vim
   :linenos:


emacs
-----

Includes emacs.nox

emacs.nox
---------

Installs emacs without X11 support.

init
----

The init.sls includes vim and emacs without X11 support.

