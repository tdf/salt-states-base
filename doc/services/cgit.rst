.. index:: pair: service; cgit

.. _cgit_service:

CGit
====

CGit is a web-gui like gitweb.

Installation
------------

* cgit Source is available on http://hjemli.net/git/cgit/

* Rene has build a .deb package.

  .. todo::

  Rene built one quick and dirty and he wanted to build a right one later.
  Ping Rene on it.

    Link to the CGit deb package from Rene incl. sources

* Installation::

    apt-get install cgit*.deb

* Apache config file :file:`/etc/apache2/conf.d/cgit`:

  .. code-block:: apache

    Alias /cgit/cgit.css /var/www/htdocs/cgit/cgit.css
    Alias /cgit/cgit.png /var/www/htdocs/cgit/cgit.png
    Alias /cgit /var/www/htdocs/cgit/cgit.cgi

    <Directory /var/www/htdocs/cgit>
      Options FollowSymLinks +ExecCGI
      AddHandler cgi-script .cgi
    </Directory>

* Configuration of cgit in :file:`etc/cgitrc`::

    # Enable caching of up to 1000 output entriess
    cache-size=1000

    # Specify some default clone prefixes
    clone-prefix=git://anongit.freedesktop.org/libreoffice ssh://anongit.freedesktop.org/libreoffice http://anongit.freedesktop.org/git/libreoffice

    # Specify the css url
    css=/cgit/cgit.css

    # Show extra links for each repository on the index page
    enable-index-links=1

    # Show number of affected files per commit on the log pages
    enable-log-filecount=1

    # Show number of added/removed lines per commit on the log pages
    enable-log-linecount=1

    # Add a cgit favicon
    favicon=/favicon.ico

    # Use a custom logo
    logo=/cgit/cgit.png

    # Set the title and heading of the repository index page
    root-title=foobar.com git repositories

    # Set a subheading for the repository index page
    root-desc=tracking the foobar development

    # Include some more info about foobar.com on the index page
    root-readme=/var/www/htdocs/about.html

    # Allow download of tar.gz, tar.bz and zip-files
    snapshots=tar.gz tar.bz zip

    ##
    ## List of repositories.
    ## PS: Any repositories listed when repo.group is unset will not be
    ##     displayed under a group heading
    ## PPS: This list could be kept in a different file (e.g. '/etc/cgitrepos')
    ##      and included like this:
    ##        include=/etc/cgitrepos
    ##

    # scan
    scan-path=/home/gerrit/gerrit_lo/git/

    # Disable adhoc downloads of this repo
    repo.snapshots=0

    # Disable line-counts for this repo
    repo.enable-log-linecount=0

* Config of Apache vserver

  .. todo::

    Describe CGit Vserver File

  .. code-block:: apache

    ProxyPass  /cgin  !

* Config of gerrit::

    [gitweb]
      url = https://gerrit.libreoffice.org/cgit
      linkname = cgit
      revision = /${project}.git/commit?id=${commit}
      project = /${project}.git
      branch = /${project}.git/branches/${branch}
      filehistory = /${project}.git/commits/${branch}/${file}

  .. todo::

    State gerrit config-file for cgit additions.


Responsible
-----------

Ostrovsky, David <d.ostrovsky@idaia.de>

Engelhard, Rene <rene.engelhard@documentfoundation.org>

Einsle, Robert <r.einsle@documentfoundation.org>
