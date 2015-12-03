.. index:: pair: service; plone

Plone
================


Plone is a "content management system" / document management system.

Installation
------------

The current version of Plone (4.2.x) runs on Python 2.7.x. Thus it is necessary that Python 2.7.x and it's dev-packages are installed::

  apt-get install python2.7 python2.7-dev python-virtualenv

It is also very useful to create an virtualenv for the Python used to run Plone. This needs an Python-virtualenv package installed.
It's also necessary to use distribute for the buildout. Thus it could also be used for the virtualenvironment::

  virtualenv --distribute /????/plone-python

This environment has to be activated by going to the created virtualenvironment and::

  cd /????/plone-python; source bin/activate

The creation of a Plone buildout starts with making a directory inside /var/www with a proper naming::

  mkdir /var/www/instancename

Inside this directory get the bootstrap file with (example for version 4.2)::

  cd /var/www/instancename; wget https://raw.github.com/plone/buildout.coredev/4.2/bootstrap.py

It's important to get the proper bootstrap file because that works usually only with one main version.

Once the bootstrap file is inside the buildout directory create a buildout.cfg file (and maybe another one for
a different deployment). The buildout environment of TDF contain a buildout.cfg for the base buildout setting
and a zeo.cfg for the special settings of the zeoserver environment with two and more instances. We use the
zeoserver version for the deployment of the extensions-site etc.

The buildout.cfg file looks like this:

.. code-block:: ini

    [buildout]
    parts =
        instance
        zopepy
        i18ndude
        zopeskel
        test
        backup

    extends =
        http://dist.plone.org/release/4.2.4/versions.cfg


    find-links =
        http://dist.plone.org/release/4.2.4
        http://dist.plone.org/thirdparty

    extensions =
        mr.developer
        buildout.dumppickedversions
        buildout.threatlevel

    auto-checkout =
        tdf.extensionsiteaccountform
        tdf.templatesiteaccountform

    always-checkout = true  #could be changed to false, if nothing is to checkout from a source directory

    sources = sources

    versions = versions

    # Reference any folders where you have Python egg source code under development here
    # e.g.: develop = src/my.package
    # If you are using the mr.developer extension and have the source code in a
    # repository mr.developer will handle this automatically for you
    develop =
             src/tdf.extensionsitepolicy
             src/tdf.extensionsiteaccountform
             src/tdf.templatesiteaccountform
             (...)

    # Create bin/instance command to manage Zope start up and shutdown
    [instance]
    recipe = plone.recipe.zope2instance
    zeo-address = <port number for zeoserver>
    user = admin:<admin-password>
    http-address = <port number for instance>  #this had to be openened in the firewall
    debug-mode = off
    verbose-security = off
    blob-storage = ${buildout:directory}/var/blobstorage

    eggs =
           tdf.extensionsitepolicy   #we add only one egg here that contains every package that is needed for the specific site


   # Some pre-Plone 3.3 packages may need you to register the package name here in
   # order their configure.zcml to be run (http://plone.org/products/plone/roadmap/247)
   # - this is never required for packages in the Products namespace (Products.*)
   zcml =
          collective.psc.blobstorage       #here we add all package names that need a zcml slug

   # zopepy commands allows you to execute Python scripts using a PYTHONPATH
   # including all the configured eggs
   [zopepy]
   recipe = zc.recipe.egg
   eggs = ${instance:eggs}
   interpreter = zopepy
   scripts = zopepy

   # create bin/i18ndude command
   [i18ndude]
   unzip = true
   recipe = zc.recipe.egg
   eggs = i18ndude

   # create bin/test command
   [test]
   recipe = zc.recipe.testrunner
   defaults = ['--auto-color', '--auto-progress']
   eggs =
         ${instance:eggs}

   # create ZopeSkel command
   [zopeskel]
   unzip = true
   recipe = zc.recipe.egg
   eggs =
       ZopeSkel
       ${instance:eggs}


   [sources]  #list to sources that are downloaded from the internet (git or svn) or reside only inside "src": then use "fs" instead of an url
   collective.developermanual = svn http://svn.plone.org/svn/collective/collective.developermanual
   Products.PloneSoftwareCenter = git git://github.com/collective/Products.PloneSoftwareCenter.git
   collective.psc.blobstorage = fs collective.psc.blobstorage
   tdf.extensionsitepolicy = fs tdf.extensionsitepolicy
   tdf.extensionsiteaccountform = git git://github.com/andreasma/tdf.extensionsiteaccountform.git
   tdf.templatesiteaccountform = git git://github.com/andreasma/tdf.templatesiteaccountform.git

   # Version pindowns for new style products go here - this section extends one provided in http://dist.plone.org/release/
   # If we use buildout.dumppickedversions in the buildout we get a list with the used versions at the end of the buildout process
   # that we could copy into this section to pin the packages for further run of the buildout script
   [versions]

   Cheetah = 2.2.1
   Pillow = 1.7.8
   Products.AddRemoveWidget = 1.5.0
   (...)

   [backup]
   recipe = collective.recipe.backup
   location = var/backups
   snapshotlocation = var/snapshotbackups
   backup_blobs = true



Because we create a zeoserver that runs more than one instance we create a second buildout script "zeo.cfg"
that contains additions to the buildout basics. This script extends buildout.cfg:

.. code-block:: nginx

  [buildout]
  extends = buildout.cfg
  parts += zeoserver instance2

  [zeoserver]
  recipe = plone.recipe.zeoserver
  zeo-address = <port of the zeoserver>

  [instance]
  shared-blob = on
  zeo-client = on
  zeo-address = <port of the instance>         #had to be the same as in buildout.cfg
  eggs +=


  [instance2]
  recipe = collective.recipe.zope2cluster
  instance-clone = instance
  http-address = <port of the second instance>  #had to be opened in the firewall
  debug-mode = off
  verbose-security = off



Once this both scripts are finished we run the bootstrap script.

Therefore activate first the Python virtual environment. You should see a change in the prompt of the bash.

Then go to the buildout directory and run::

  python bootstrap.py

This creates the buildout Python script and the whole buildout subfolder structure.

If there are some packages that should be in src and will not be downloaded from a source directory in the internet
please copy the source into the src subfolder.

Once this is done run buildout by::

  ./bin/buildout -c zeo.cfg

The -c is a switch to change from the default buildout.cfg to another buildout script.

The buildout will run for a while then (go for a coffee or tee ;-)

It downloads all the necessary source and will compile it and create Python eggs (they are by default in the eggs subfolder of the buildout).

If nothing bad happens (e.g. issue with dependency) the buildout creates a zeoserver with two instances and shows a list of the specific
packages with versions that are used for this buildout. After the first run of buildout (and after a rerun with an additional egg) this list
should be copied to the versions section of the buildout.cfg.



Start
-----

::

  ./bin/zeoserver start
  ./bin/instance start
  ./bin/instance2 start   #if a second instance is needed

  # If there are an issue with instance run an instance in foreground mode with:
  ./bin/instance fg

  # It is posible to find out wether the instance / daemon is running or passed by with:
  ./bin/instance status

This gives also the number of the process of the instance back. If this process number changes once the status
command is executed again there is something wrong in the buildout scripts (e.g. port numbers) or an issue with
a dependency of the packages.


If you control the status of the instance(s) and get different port numbers in the messages, if you run the status request more than one time,
there will be something wrong in the buildout environment. In this case look
into the instance log and try to find out, if there is an e.g. an issue to get
in contact with the zeoserver.

Stop
----

::

  # The stop of the Plone zeoserver works in this direction (first instances and at last the zeoserver):

  ./bin/instance stop
  ./bin/instance2 stop   #if a second instance is running
  ./bin/zeoserver stop



Development Environment with Vagrant and Virtualbox
---------------------------------------------------

If we want to set up a test and development environment that is seperated from
the operating system of the host system we could create a virtual environment
using Vagrant and Virtualbox.

First we need to install Virtualbox with all Kernel modules. We could use the
Virtualbox packages from our distribution or download the newest version from
http://virtualbox.org.

Once Virtualbox is on the system install Vagrant: a distribution package or go
to http://www.vagrantup.com and download the appropriate package from there
(and install it from command line).

If we'll use Virtualbox 4.2.14 we may run into an issue with a line like:
Progress object failure: NS_ERROR_CALL_FAILED
at the end.

If this occurs we may have an issue with importing appliances without
manifests. We could solve this problem with:

going to ~/.vagrant.d/boxes/MyBoxName/virtualbox and doing

::

   openssl sha1 *.vmdk *.ovf > box.mf

* Download and unpack coredev.vagrant
  from https://github.com/plone/coredev.vagrant/archive/master.zip.

* Open a command prompt; change directory into the
  coredev.vagrant-master directory and issue the command "vagrant up".

* Go for lunch or a long coffee break. "vagrant up" is going to download a
  virtual box kit (unless you already happen to have a match installed), clone
  buildout.coredev and set up some convenience scripts.

* Look to see if the install ran well. The virtual machine will be running at
  this point.


While running "vagrant up", feel free to ignore messages like "stdin: is not a
tty" and "warning: Could not retrieve fact fqdn". They have no significance in
this context.

Using the Vagrant-installed VirtualBox
--------------------------------------

You may now start and stop the virtual machine by issuing command in the same
directory.

Stopping:

::

   vagrant suspend


Restart:

::

   vagrant resume


Removing the Virtualbox:

::

   vagrant destroy


Note that port 8080 on the host system will be in use whenever the guest system
is up. Halt it to clear the port.


Running Plone and buildout
--------------------------

To run buildout, just type the command:

::

   ./runbin.sh buildout

This will run buildout; add command line arguments as desired.

Expect your first coredev buildout to take some time. It may even timeout. Just
run again until it finishes. Subsequent builds will be faster.

To start Plone in the foreground (so you could see its messages in the shell),
use the command:

::

   ./runbin.sh instance fg

Plone will be connected to port 8080 on the host machine, so that you should be
able to start a web browser, point it at http://localhost:8080 and see
Zope/Plone.

Plone is installed with an administrative user with id "admin" and password
"admin".

Stop foreground Plone by using the site-setup maintenance stop button or by just
pressing ctrl-c.

If you use ctrl-c, you'll need to do a little cleanup. Plone will
still be running on the virtual box. Kill it with the command:

::

   ./kill_plone

To run a test suite, use a command like:

::

   ./runbin test -s plonetheme.sunburst

Editing Plone configuration and source files
--------------------------------------------

After running "vagrant up", you should have a buildout.coredev subdirectory. In
it, you'll find your buildout configuration files and a "src" directory. These
are the matching items from a normal coredev installation. You may edit all the
files.

All of this is happening in a directory that is shared with the guest operating
system, and the .cfg files and src directory are linked back to the working copy
of coredev on the guest machine. All the rest of the install is on the guest
system only.

Administration from Command Line
--------------------------------

It's possible to make some administration of a Plone site from the command line,
thus you have not to use a webbrowser and a GUI.


If the Plone instance is created using buildout you can add an new admin user to the
Plone instance, especially if you have locked yourself out (or lost the credentials):

::

    bin/instance adduser user1 password1
    
See a more in detail description: https://plone.org/documentation/faq/locked-out


You can also run Python scripts from the command line in such an instance with:


::

    ./bin/instance run [path_to_your_python_script]
    

    
Get a memberlist out of your Plone instance (getMemberList.py):

.. code-block:: getMemberlist
   
   from Products.CMFCore.utils import getToolByName
   membership = getToolByName(app.[name of the Plone site], 'portal_membership')
   for member in membership.listMembers():
      print member.getProperty('id'), member.getProperty('fullname'), member.getProperty('email')



Responsible
-----------

Andreas Mantke <andreas.mantke@documentfoundation.org>
