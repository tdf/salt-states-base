AOO SVN -> git import tool
==========================

Mirrors the AOO changes to the LibreOffice git repository as aoo/trunk.

Installation
------------

.. note::

  You do not want to re-install this, instead copy it from the old location or
  from backup!  Mirroring of the SVN so that you can start the migration takes
  about 1.5 months.  No kidding, months!  Really.

* Creating a new User before you fill in the /home/svngit::

    sudo adduser svngit
    usermod -s /bin/false svngit
    usermod -l svngit

* Copy the backup or old location to the /home/svngit::

    mv /home/svngit /home/svngit.save
    cp -a <backup-location>/svngit /home/svngit

* Install crontab::

    sudo crontab -u svngit -e

    and add the following line there so that the conversion is run every 2
    hours:

    5 */2 * * * /home/svngit/bin/svngit-full-conversion.sh

* Layout of /home/svngit::

    aoo-svn: Mirror of the AOO svn, that was created using svnsync, and being
    updated using svnsync synchronize.  In case anybody needed to re-do this
    (and could afford 1.5 months of waiting before the svnsync finishes), the
    instructions are here:

        http://svn.apache.org/repos/asf/subversion/trunk/notes/svnsync.txt

    conversion.AOO*: temporary files & dirs created during conversion

    git: reference git repo used a base for the conversion

    svn-to-git: The conversion tool itself.  The sources live here:

        http://cgit.freedesktop.org/libreoffice/contrib/svn-to-git/

    bin/svngit-full-conversion.sh: The cron script that takes care of calling
    the svn-to-git tooling.

* Notes

    After the migration, do a test run of bin/svngit-full-conversion.sh ,
    and check conversion.AOO.log that there are no errors there.  If it ends
    up with an errror, contact kendy@collabora.com.

Responsible
-----------

Holesovsky, Jan  <kendy@suse.cz>
