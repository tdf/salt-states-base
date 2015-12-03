.. _gitolite_service:

Gitolite
================

Gitolite is a GIT-repository management tool.


Installation
------------

* Install git and configure it for your user::

    sudo apt-get install git-core
    git config --global user.name "Your Name"
    git config --global user.email your@email.com
    git config --global color.ui auto

* Install gitolite::

    sudo apt-get install gitolite

* Create a user that gitolite runs under::

    sudo adduser \
    --system \
    --shell /bin/bash \
    --gecos 'git version control' \
    --group \
    --disabled-password \
    --home /srv/git \
    git

* Create a file containing your public ssh-key at :file:`/srv/git/myusername.pub`

* Run the gitolite setup for the git user::

    sudo su git
    gl-setup /srv/git/myusername.pub

* Change the umask of the repositories::

    sed -ie 's/^\$REPO_UMASK.*$/$REPO_UMASK = 0027;/' /srv/git/.gitolite.rc

* Allow hook-options in the admin repo::

    sed -ie 's/^#*\$GL_GITCONFIG_KEYS.*$/$GL_GITCONFIG_KEYS = "hooks\\..*";/g' /srv/git/.gitolite.rc

* Add the file :file:`/srv/git/.gitolite/hooks/common/post-receive`:

.. literalinclude:: /doc/files/gitolite/post-receive
   :language: bash

* Add the file :file:`/srv/git/.gitolite/hooks/common/post-receive.mail`:

.. literalinclude:: /doc/files/gitolite/post-receive.mail
   :language: bash

* Update the hooks in the repositories::

    sudo su git
    gl-setup

* Try to clone the admin repository from your local pc::

    git clone git@hostname:gitolite-admin.git





Start
-----

This service has no daemon that needs to be started/stopped



Stop
----

This service has no daemon that needs to be started/stopped




Disable
-------

::

  sudo chsh -s /usr/sbin/nologin git



Enable
------

::

  sudo chsh -s /bin/bash git



Responsible
-----------

Alexander Werner <alex@documentfoundation.org>
Robert Einsle <r.einsle@documentfoundation.org>