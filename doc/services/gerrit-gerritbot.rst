.. _gerritbot:

Gerritbot
=========

Installation
------------

To install gerritbot:

* install prerequisites::

    sudo apt-get install python getmail4 procmail

* create a user gerritbot and log in as it::

    sudo useradd -m gerritbot -s /bin/false
    sudo bash
    sudo gerritbot

* get the source::

    git clone http://cgit.freedesktop.org/libreoffice/contrib/dev-tools

* link the files in the user root::

    export HOME=/home/gerritbot
    mkdir ~/.ssh
    ln -s ~/dev-tools/gerritbot/.ssh/config -t .ssh
    mkdir ~/.getmail
    ln -s ~/dev-tools/gerritbot/getmailrc -t .getmail
    ln -s ~/dev-tools/gerritbot/.procmailrc
    ln -s ~/dev-tools/gerritbot/.muttrc #optional

* add the private key for gerrit access to :file:`~/.ssh/id_rsa`:

  - if the key was lost, a new one needs to be uploaded to gerrit
  - the OpenID for it is: ``https://launchpad.net/~r-gerrit-0``
  - the OpenID is bound to ``gerrit@libreoffice.org``

* set the password for ``gerrit@libreoffice.org`` in :file:`.getmail/getmailrc`

* install the crontab::

    crontab ~/dev-tools/gerritbot/crontab.txt

* done


Start & Enable
--------------

::

    crontab ~/dev-tools/gerritbot/crontab.txt


Stop & Disable
--------------

::

    sudo gerritbot
    crontab -r



Responsible
-----------

Bjoern Michaelsen <bjoern.michaelsen@canonical.com>
