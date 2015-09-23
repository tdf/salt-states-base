======
Editor
======

.. image:: http://vm170.documentfoundation.org/badge/editor/debian:7

.. image:: http://vm170.documentfoundation.org/badge/editor/ubuntu:12.04

.. image:: http://vm170.documentfoundation.org/badge/editor/ubuntu:14.04

.. image:: http://vm170.documentfoundation.org/badge/editor/debian:8

.. image:: http://vm170.documentfoundation.org/badge/editor/centos:7

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

