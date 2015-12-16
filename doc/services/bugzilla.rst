Bugzilla
========

Bugzilla is our issue-tracking system for LibreOffice and various DLP libraries.

* https://www.bugzilla.org/
* https://www.bugzilla.org/docs/4.4/

Installation: Are you using Salt?
---------------------------------

If you're setting up a VM using the Saltstack configuration tool
("Salt" from here on), much of the content below will be redundant.

Are you installing manually?
----------------------------

If you're *not* using Salt directly, you'll want to read through the
tdf salt git repository for information, especially within the
salt/tdf/bugzilla directory. The scripts are usually pretty
descriptive, and will help you to install and configure nginx,
postgres, bugzilla, and all the other important pieces.

I usually start with the :file:`init.sls`, but I do suggest reading
through all the files first, before starting any install.

How to set up an instance of Bugzilla like ours for testing/development
-----------------------------------------------------------------------

**NOTE:** The TDF/LibreOffice installation of Bugzilla is slightly
different from the stock install: Instead of Apache + MySQL, we use
Nginx + Postgres. It’s very likely that you can work on patches in an
environment using a different web server and db engine, but if you
intend to provide patches for deployment with our installation, please
make sure the changes are thoroughly reviewed on our bugzilla-test VM

.. todo::
  *[will link to page for The Bz-Test VM here]*.

How to configure the base machine and OS
----------------------------------------

Our base machine is currently running Debian 7.9

* (A modern version of Ubuntu such as 14.04 should work very similarly)

To simplify the install process, here are some pre-defined values *(as specified in the salt config)*:

* The webserver (nginx) is running as www-data
* Bugzilla is running as the user bugzilla
* The files in the installation are chowned to: bugzilla:www-data

Required libraries: What can be installed from package manager
--------------------------------------------------------------

The following packages should be installed via the package manager (apt):

.. code-block:: bash

    sudo apt-get install \
    nginx \
    postgresql \
    postgresql-client \
    #postfix-policyd-spf-python \
    libhtml-template-perl \
    perl \
    python \
    postfix \
    postfix-pcre \
    \
    git \

    # For getting the graphing capabilities working
    sudo apt-get install \
    graphviz \

    # Extras
    # (OPTIONAL) Nice editors and virtual terminals can be very handy,
    # esp. with remote systems.
    sudo apt-get install \
    byobu \
    vim \
    emacs23-nox

    # Many perl libraries for Bugzilla itself
    sudo apt-get install \
    libsoap-lite-perl \
    libjson-rpc-perl \
    libemail-send-perl \
    libmath-random-isaac-perl \
    libemail-mime-creator-perl \
    libemail-mime-perl \
    libtest-taint-perl \
    libdbd-pg-perl \
    libdatetime-timezone-perl \
    libjson-xs-perl \
    libtheschwartz-perl \
    perlmagick \
    libemail-mime-modifier-perl \
    libchart-perl \
    libxml-twig-perl \
    libtemplate-perl \
    libdatetime-perl \
    libnet-smtp-ssl-perl \
    libgd-graph-perl \
    libtemplate-plugin-gd-perl \
    libhtml-scrubber-perl \
    libhtml-formattext-withlinks-perl \
    libfile-mimeinfo-perl

    sudo apt-get install \
    xmlto \
    tidy \
    curl \
    xsltproc \
    make

    # Do not install Bugzilla from apt. We maintain our own version!
    # bugzilla


How to install Bugzilla with non-standard db and web server
-----------------------------------------------------------

Our setup:

* We're installing Bugzilla in :file:`/srv/bugzilla/`

As mentioned previously, to manually install you'll want to follow the
information the salt config. For example, here's the setup for
Bugzilla:

.. code-block:: bash

    # Create the directory, user, and then set ownership:
    # (as root)
    mkdir /srv/bugzilla
    useradd -d /srv/bugzilla -p foobar bugzilla
    chown bugzilla:www-data /srv/bugzilla
    chmod g+s /srv/bugzilla

Getting source from gerrit
``````````````````````````

Our copy of the source code for Bugzilla, including the upstream code
plus our local templates, modifications, and patches, lives in a git
repository in Gerrit:

.. code-block:: text

  https://gerrit.libreoffice.org/#/admin/projects/bugzilla

For each upstream Bugzilla version that's been deployed, we have a
local branch in our repository that graft our local changes on top of
the upstream development. So for Bugzilla 4.4.10, we have

.. code-block:: text

   Upstream Tag: release-4.4.10
   Our Repository: tdf-4.4.10

If you want to get the code *and* contribute changes, you'll need a
Gerrit account. The `Gerrit wiki page
<https://wiki.documentfoundation.org/Gerrit>`_ has some information
that is described in the context of contributing to LibreOffice core,
however nearly all of the information is also relevant to contributing
to Bugzilla. Additional information is available on the `QA Bugzilla
Development
<https://wiki.documentfoundation.org/QA/Bugzilla/Development>`_ wiki
page.

If you'd just like to get the Bugzilla code without signing up for
Gerrit, you can clone the source directly:

.. code-block:: bash

    # (as root)
    su bugzilla
    cd    # you should be in /srv/bugzilla
    pwd   # double-check that the home dir is set correctly
    git clone git://gerrit.libreoffice.org/bugzilla bugzilla-4.4.10
    # check out the latest version that tdf is using
    git checkout tdf-4.4.10  

Nginx
-----

Nginx config, fcgiwrap, perl-fcgi, etc.. are all currently stored in
Salt, alongside the :file:`init.sls` file we mentioned earlier. Follow
the salt steps to manually to configure the webserver and CGI
environment.

*Warning:* Before deploying any public-facing services such as
Bugzilla or nginx, please make sure that you're not just using our
sample configurations without change. They're perfectly fine to use
as-is on a private VM, but need careful consideration before public
deployment.

Postgres
--------

Simple postgresql information is described in the :file:`init.sls`
file.

For example, create and add the bugzilla database and user:

.. code-block:: bash

  # (as root)
  su - postgres
  psql  # now you're opening the postgres command-line interface
  postgres=# CREATE USER bugzilla WITH PASSWORD 'foobar';
  postgres=# CREATE DATABASE bugzilla;
  postgres=# GRANT ALL PRIVILEGES ON DATABASE bugzilla to bugzilla;
 
  # Confirm that the account, db, and grant succeeded:
  postgres=# \q     # quit the postgres command-line interface
  $ psql -h localhost -d bugzilla -U bugzilla -W
      # Enter bugzilla's password at the prompt, and voila:
 
  SSL connection (cipher: DHE-RSA-AES256-GCM-SHA384, bits: 256)
  Type "help" for help.
 
  bugzilla=> \q      # to quit the command-line interface


Config data: data/params, the database, and localconfig
-------------------------------------------------------

The configuration details, metadata, etc.. is split between the
:file:`data/params` file, the :file:`localconfig` file, and the database itself.
Generally speaking, site-wide values are stored in data/params, and
product/component-level values are stored in the database. The
Bugzilla docs go into greater detail about the particulars of the
stock install.

Pre-defined Values:

* There are several pre-defined values in the params file and our salt config that need to be tweaked for your install
* We're assuming Bugzilla is running with SSL, with an SSL base of https://bugs.documentfoundation.org/
* Also see the fields for: *maintainer, mailfrom, urlbase* and *attachment_base*

In the TDF Bugzilla we have made several changes and additions to the
params. We've used this data store for new variables, such as
*tdf_contrib_warning*, a string we use in multiple templates to
clarify to our users the conditions under which they may use our
bugtracker (mentioned below). Storing additional values in the params
file can be very useful, but make sure to register changes or new
parameters under :file:`Bugzilla/Config/General.pm`. For more details, see
*commit ffe4140b "Config: Explicitly specify tdf_contrib_warning..."*
for an example of how we made our modifications.

localconfig
-----------

The localconfig file is stored in Salt, and contains additional
sitewide configuration, as well as private credentials. Grab the
:file:`localconfig` file from the Salt repo
(salt/tdf/bugzilla/localconfig) and put it at the top level of the
bugzilla checkout. You'll need to set some values:

.. code-block:: text

 $db_name, $db_user, $db_pass

For the *$site_wide_secret*, you'll just want to leave that field
blank and have it be regenerated the first time Bugzilla is run.

Checksetup.pl
-------------

After installing Bugzilla, or making changes to templates, parameters,
code, and other program resources, Bugzilla recommends that one re-run
the top-level script :file:`./checksetup.pl`. This script does a lot
of useful things, including helping to diagnose missing installation
dependencies, compiling template and data parameters whenever Bugzilla
is upgraded, and adding admin accounts.

During the initial install, you may need to select and install a large
number of Perl libraries.

Adding new admin accounts
-------------------------

User accounts may be granted additional rights via the Administration
menu in the web interface, but it is often convenient to add one or
more administrators via the command line. The swiss-army-knife
:file:`checksetup.pl` script is used for this purpose:

MAKE SURE to run this as the bugzilla user:

.. code-block:: bash

    # cd /srv/bugzilla
    # sudo -u bugzilla ./checksetup.pl --make-admin <some-email-account-in-the-system>

It doesn't hurt to re-run the checksetup script after creating the admin

.. code-block:: bash

    # sudo -u bugzilla ./checksetup.pl

Tip about passwords
-------------------

If you run into problems with your initial site configuration, you may
receive a password reset email that is missing a base url. The
quick-fix for this issue, (so that you can get back to an admin web
interface) is to just manually paste it onto the end of the base
hostname/path to Bugzilla.

So if your install is at

 http://localhost/bugs

And your link is like

 token.cgi?t=dDATrqMoHz&a=cfmpw

Then combine:

 http://localhost/bugs/token.cgi?t=dDATrqMoHz&a=cfmpw

Most important changes we've made to the Buzilla software
---------------------------------------------------------

Licensing
`````````

We've made the licensing of our bug data very explicit, providing
clear licensing information on multiple pages, in particular focusing
on the point when users upload new attachments.

Here's the current message (*tdf_contrib_warning*) we provide in the
page footer:

 Copyright information: Please note that all contributions to The
 Document Foundation Bugzilla are considered to be released under the
 `Creative Commons Attribution-ShareAlike 4.0 International License
 <http://creativecommons.org/licenses/by-sa/4.0/>`_, unless otherwise
 specified. Source code form contributions such as patches are
 considered to be modifications under the `Mozilla Public License v2.0
 <http://www.libreoffice.org/download/license/>`_.


Defaults (values)
`````````````````

New icons and logos
'''''''''''''''''''

We've added new icons and logos from time to time to customize the
look and feel of Bugzilla. One of the easiest changes one can make is
to create new graphics for Bugzilla -- especially a banner or other
display for the front page or sidebar of the site.

Extensive customization is available, but for a quick example, see
commit "Dress-up Bugzilla to promote DFD 2015" to see how we modified
the *announcehtml* field in :file:`data/params` and added a splashy image.

Guided Forms
------------

How to configure info for Bugzilla Guided Forms
```````````````````````````````````````````````

Bugzilla Guided Forms are a hidden 'gem' of Bugzilla, and we're using
them to help users provide better bug reports, as well as simplifying
the process of bug reporting. The forms tie-in to the same mechanisms
used for the regular bug-creation forms, but provide much more context
and many more hints.

Updating form info
``````````````````

As template files, most of the Guided Form modifications can be made
directly in the HTML of the page, which should be accessible to a wide
audience. Some more advanced tweaks do require modification of the
templating code itself, for which I suggest that our list of existing
modifications be read and used as examples.

Modifications made for Guided Forms
```````````````````````````````````

Most information about our modifications to the Guided Forms
functionality of Bugzilla can be found in the commit log -- just look
for commits titled "Guided Forms:...". We've added new fields, tweaked
values of the OS, and provided much clearer and appropriate examples
for descriptions.

Example: *commit 14e7060a, "Guided Forms: Make top of page
notification optional"*, which touches
:file:`template/en/default/bug/create/create-guided.html.tmpl`

Including new passed-in information in the forms is straightforward.
See the commit *"Guided Forms: Include UserProfile and Additional
info..."* for a look at our modifications.

Reporting bugs from within LibreOffice
--------------------------------------

To make it easier for users to report bugs and accurately provide
information about the version of LibreOffice and Component they're
using, we've provided a menu option inside the office suite that opens
a link to our website, passing-along important information as HTML
variables.

One goal is to improve the code that handles the incoming data, to
better auto-triage the bug report before it's reviewed in person.

* Also see the `Javascript code <https://wiki.documentfoundation.org/QA/Bugzilla/Parsing_params_from_LibreOffice>`_ we use to parse incoming application data

Configuring local graphviz
--------------------------

For many years Bugzilla installs relied on an AT&T dot server for
graphing, however as that server is no longer available, we will set
up our own local `dot server <https://en.wikipedia.org/wiki/DOT_language>`_.

Install the graphviz package:

.. code-block:: bash

 # (as root)
 apt-get install graphviz

Update the *webdotbase* value in the :file:`data/params` file to be
'/usr/bin/dot'. You can edit the text of this file directly on the
server, or via the Administration interface:

.. code-block:: text

  https://<server-hostname-or-ip-address>/editparams.cgi?section=dependencygraph

* Not much space is needed -- the current data/webdot/ directory for production only contains 344K of PNG and MAP files

* See *commit "redmine#934: Use local graphiviz instead of ATT remote"* for details of our tweaks and upstream issue

Configuring charts and reports
------------------------------

Bugzilla has multiple mechanisms for creating charts and reports, some
of which have required some tinkering to get running properly.

Re-generating chart files on disk
`````````````````````````````````

To make historical information available, you'll need to regenerate
old report data to fully mimic the current TDF setup of Bugzilla:

.. code-block:: bash

 # (as the bugzilla user)
 # cd to the Bugzilla installation directory, then
 time ./collectstats.pl --regenerate

If we don't re/generate the data, then our graphs will never gain
points over time. If we just set up a cron job without a first
regeneration run, the first cron run could take a VERY long time (and
might be incorrectly seen as a wedged process).

How to re-create what Salt does, but by hand
--------------------------------------------

Cron jobs
`````````

Several regular tasks need to be configured as cron jobs, including
the collectstats.pl script. For the specifics, see the *init.sls*
file.

* Collectstats.pl -- Collect data for web graphs

  * Confirm the results here: https://bugs.documentfoundation.org/reports.cgi
  * Run daily

* Whine.pl -- Whining notifications (self-requested by users)

  * To test, go here: https://bugs.documentfoundation.org/editwhines.cgi
  * Run every 15 minutes

Private information
```````````````````

We use Salt to help us deploy some private information such as:

* Database password
* Secret token for the install

Whenever the Salt docs (e.g. *init.sls*) reference pillar
information, that's something that you'll need to specify yourself,
whether you are using salt to configure Bugzilla as we do, or whether
you're manually installing all the pieces.

Keeping Bugzilla up to date
---------------------------

If you're running a local VM on your machine with no external access,
then keeping Bugzilla up to date is minor issue. If you're using the
bug tracker in a production environment, you'll want to pay much more
attention to the development progress of new upgrades and patches from
Mozilla and TDF.

For most other software on your machine, the package manager should
keep the base software up to date. For Bugzilla, you'll want to
subscribe to the `support-bugzilla mailing list
<https://lists.mozilla.org/listinfo/support-bugzilla>`_ which will
keep you up to date with information about security upgrades, as well
as pay attention to the `libreoffice-qa mailing list
<https://wiki.documentfoundation.org/QA/Mailing_List>`_ on which we
announce upgrades to Bugzilla.

For development, you'll probably want to see both the current TDF
branches as well as the upstream branches on which they are based.

First, add upstream as a new remote:

.. code-block:: bash

   git remote add upstream https://git.mozilla.org/bugzilla/bugzilla.git

Edit branches in .git/config to point to upstream instead of origin:

.. code-block:: bash

   # Note: We could probably get away without this, as we only build on
   # top of tagged versions
   [branch "master"]
       remote = upstream
       merge = refs/heads/master

Update the remotes, pulling down the Bugzilla git history

.. code-block:: bash

    git remote update

Changes we've made from the stock Mozilla installation
------------------------------------------------------

*NOTE:* Our Bugzilla system has always been a little different, as
we didn't set up a fresh new install of Bugzilla, but migrated our
data away from Freedesktop.org's infrastructure. We thus have
inherited some quirks and details with our installation. Several of
those quirks are described above; the rest are listed here:

FDO's WeeklyBugSummary extension
````````````````````````````````

Inherited from Freedesktop, this code lives in
:file:`extensions/WeeklyBugSummary/`. The extension doesn't require any
special setup. It provides a stats round-up of information from the
past week. See it in action here:

* https://bugs.documentfoundation.org/page.cgi?id=weekly-bug-summary.html

Added additional header/footer and attachment page info re: licensing
`````````````````````````````````````````````````````````````````````

*(see above)*, as well as *commit f1b5778: redmine#1276 - Add
additional link to 'My Bugs' in header*.

Customized warning pages for invalid password and password reset
````````````````````````````````````````````````````````````````

We've customized the warning pages for invalid passwords and password
reset to ask the user if they've changed their password since we
migrated Bugzilla from Freedesktop. By this point, we've probably had
most of our still-active contributors make the switch to the new URL
and reset their account already, but we'll probably leave a small
fdo-migration message in place going forward, just for the users who
would very much like their originally account.

See these changes in :file:`template/en/default/global/user-error.html.tmpl`

Custom access permissions for Importance fields
-----------------------------------------------

Access to the Priority and Severity fields has been restricted, with
further tweaks to the Severity field forthcoming. New users have often
mis-prioritized bugs, ascribing levels far higher than the content of
the report would ever suggest, so restricting them slightly before
we've had an opportunity to triage the bugs ourselves seems like a
reasonable precaution.

We will continue to be very liberal about granting access to the
**Contributors** group, using group membership as a qualification for
access to the Priority and Severity fields.

Custom list/layout of Versions on New and Browser pages
```````````````````````````````````````````````````````

Due to demand, we've made the chief projects (LibreOffice and the
Impress Remote) have more room and a nicer layout on the
*enter_bug.cgi* and *describecomponents.cgi* pages. This should
speed-up bug filing considerably, and make it much easier to file one
bug after another.

Update/add field labels
-----------------------

To increase clarity for bug reporters and testers, we've made changes
to the labels of fields in Bugzilla. For example we've changed the
*Version* field to read:

.. code-block:: text

        Version
  (earliest affected)

These modifications have been quite helpful in better-communicating
our intentions to bug reporters and those triaging bug reports.
As we do employ non-standard use of several Bugzilla fields,
updated labels are an important way for us to avoid confusion and get
accurate, helpful information.



Part 2: How to administer our Bugzilla
======================================


The most common tasks of an administrator
-----------------------------------------

Administration of the TDF Bugzilla comprises various tasks, including
upgrading the software and making small improvements/updates (such as
adding new product versions, keywords, etc..), but by far the most
common task is responding to user requests or inquiries.

How to delete an attachment (if absolutely necessary)
-----------------------------------------------------

In some *very rare* instances, we may need to delete attachments
from Bugzilla.

Because we delete attachments so infrequently, we haven't worked out a
rigorous formal policy yet, but given that we provide users with
multiple warnings about the license terms and public nature of
attachments, we're only going to remove attachments if absolutely
required.

Before deleting an attachment, please do the following:

#. Check that the request is coming from the same user who uploaded
   the document, or the clear rights-holder

   * Send a confirmation email directly to the email address
     associated with the account (Don't just rely on the address in
     the Reply-to field of an emailed request)

#. Check that the attachment is not being referenced in other bug reports

   * *This is important because we don't want to 'pull the rug out'
     from under other bugs and QA activity in Bugzilla*

Deleting the attachment:

#. Navigate to the Attachment section of the Administration interface
   (Administration -> Attachments), and double-check that
   **allow_attachment_deletion** is set to "On"
#. Navigate to the bug report corresponding to the attachment, and
   click the "Details" link to the right of the attachment name
#. *Double-check* that the attachment is the correct one (id matches,
   the "created by" text matches, etc..)
#. Under **Actions:**, click the "Delete" link.
#. Give a reason for deletion, and click Ok

How to delete a bug report
--------------------------

Because of the mechanics of Bugzilla, bugs can only be deleted by
component or product. As a result, all of our TDF bugs scheduled for
deletion need to be `assigned to the component 'deletionrequest' <https://bugs.documentfoundation.org/buglist.cgi?component=deletionrequest&list_id=520167&product=LibreOffice&query_format=advanced>`_.

Actually deleting a bug
```````````````````````

#. Go through the **deletionrequest** component (linked above) and
   confirm that everything really needs to be deleted.

   * Often random bugs will show up with this component, and my
     general rule is that only bugs *clearly created for testing
     purposes* should be deleted.

     * If a bug is invalid and bad, we can just leave it in that state
       for now.
     * (If we end up with thousands and thousands of invalid bugs, we
       can have a discussion about if/when to delete them at a later
       date)

#. Turn on bug deletion

   * Go `here
     <https://bugs.documentfoundation.org/editparams.cgi?section=admin>`_
   * Switch **allowbugdeletion** to 'On'

#. Go to the `deletionrequest component
   <https://bugs.documentfoundation.org/editcomponents.cgi?action=edit&product=LibreOffice&component=deletionrequest>`_
   and click on 'Delete this component' at the bottom of the page.
#. You'll get a red Confirmation prompt along the lines of *"There are
   66 bugs entered for this component! When you delete this component,
   ALL stored bugs and their history will be deleted too."*
#. As long as everything looks kosher, click 'Yes, delete'.
#. Now IMMEDIATELY turn OFF bug deletion (before you forget!)

   * Go `here
     <https://bugs.documentfoundation.org/editparams.cgi?section=admin>`_
   * Switch **allowbugdeletion** to 'OFF'

#. You'll now need to *recreate* the deletionrequest component.

   * `click here to add one
     <https://bugs.documentfoundation.org/editcomponents.cgi?action=add&product=LibreOffice>`_
   * The *Deletionrequest default params* section below will give you
     the right values for the fields.

#. After component creation, double-check to make sure everything looks correct.

Deletionrequest default params
``````````````````````````````
To recreate the component, you'll need these values:

* **Component:** deletionrequest
* **Component Description:** Select this Component for bugs what have been created only for testing Bugzilla or Bug Submission Assistant. Bugs with this component will be deleted from time to time. Details see `here! <http://wiki.documentfoundation.org/QA/Bugzilla/Components/deletionrequest/Help>`_
* **Default Assignee:** libreoffice-bugs@lists.freedesktop.org
* **Default QA contact:**
* **Default CC List:**

How to delete/anonymize a user account
--------------------------------------

Generally speaking, we avoid **completely deleting** user accounts
and all the bugs, comments, and attachments provided, as those are
often an important part of our QA process and are items on which we
worked in good faith.

Basic: Remove all identifying metadata
``````````````````````````````````````

What we can easily do (after account ownership verification) is to go
in as an administrator and change a user's settings to something like:

* **Login Name:**  removed_0001@example.net
* **Real Name :**  -- removed --
* **Bugmail Disabled:** [check the box]    *# This will prevent most email from being sent*
* **Disable text:** removed account        *# This will prevent people from logging-in to the account*

Advanced: Deletion
``````````````````

What to do if a user requests deletion of account and all
personally-generated data (comments, bug reports, attachments, etc) ?

If a user must truly be deleted (and I will caution again about having
to take this step, especially if their contributions have been used in
commit messages, etc), then go to the Administration interface:

#. Administration -> Administrative Policies
#. Set **allowuserdeletion** to "On"
#. Go to Administration -> Users, find the user you wish to delete,
   and navigate to the individual user profile
#. After *double-checking* that this is indeed the correct account to
   destroy, click the "Delete User" button at the bottom of the page.
#. At this point, you should see a page that will talk about
   **unsafe** and **safe** side-effects that would be caused by
   removing this user. If there are any **unsafe** side-effects
   listed, you will not be able to delete the user.

                                                                               
**REMEMBER:** At this point, go back and change **allowuserdeletion** to "Off", to avoid accidents!

It is possible to directly delete a user_id from the database tables,
however there's not currently a clean way via SQL to just remove the
user and their contributions from the database. **Take any such steps
at your own risk**

* See `email thread here <http://mozilla.6506.n7.nabble.com/How-to-delete-a-user-in-Bugzilla-td58008.html>`_.

How to delete content from a bug comment
----------------------------------------

Each comment on a bug is stored in the *longdescs* table. We can't
just delete comment from the db, as that will reorder the rest of the
remaining comments (and cause more mayhem/confusion/headache). So
we'll just clear the *content* of the comment:

#. Connect to the Bugzilla database
#. Find the correct comment_id by reviewing all comments on the bug:

.. code-block:: sql

   SELECT * FROM longdescs WHERE bug_id=' *<the-bug-id>* ';

#. Now blank-out the text of the comment, or change the text if you
   just need to remove a small piece.

.. code-block:: sql

   UPDATE longdescs SET thetext="" WHERE comment_id=' *<the-comment-id>* ';


NOTE: *For the future, it might be relevant for us to consider marking some content as* private, *using groups for separation*
(`see here <https://groups.google.com/forum/#!topic/mozilla.support.bugzilla/QK6IOmTNBoY>`_)

Common cleanup tasks
--------------------

We've touched on most of the common tasks that require admin-level
privs. There will undoubtedly be more tasks, and we'll continue to
document them here. If there is something in particular that you think
is relevant to the TDF/LibreOffice Bugzilla, please make a note here,
explaining why it's relevant.

Bulk-updating bugs
------------------

Example: Using the QA Administrators bugzilla account, to bulk-notify re: dusty bugs

See some of our current procedures on the `Bugzilla Gardening
<http://wiki.documentfoundation.org/QA/Bugzilla/Gardening>`_. At the
moment in the TDF Bugzilla, most bulk-updating tasks are carried out
by Joel Madero. If additional team members are interested in helping
with these tasks, we just need to make sure that we're not working at
cross-purposes.

Using postgres for finer-grained stats
--------------------------------------

Default Assignees
`````````````````

It can be helpful to keep track of the default assignees by component:

.. code-block:: sql

 SELECT p.name AS Product,
        c.name AS Component,
        u.login_name AS DefaultAssignee,
        initialqacontact AS DefaultQA
 FROM products p, components c, profiles u
 WHERE p.id = c.product_id AND
      u.userid = c.initialowner
 ORDER BY Product, Component;


Members of a group
``````````````````

Getting a list of all users of a particular group is pretty easy

* Go to the `Edit Users <https://bugs.documentfoundation.org/editusers.cgi>`_ page
* Restrict the search to the particular group in which you're interested

Sometimes you may want to further-restrict the search. So here's the
basic search as you would run it as SQL:

.. code-block:: sql

 SELECT p.login_name AS User,
        ug.isbless AS "can grant privs?"
 FROM profiles p, user_group_map ug
 WHERE ug.group_id = 27 AND   -- 'contributors' has group.id = 27
       p.userid = ug.user_id;


*(Note that even though one might not have the can-grant-privs flag
set, if they are a Bugzilla admin, they'll have enough power to grant
privs)*

Further information
```````````````````

See the `Bugzilla Administration <http://wiki.documentfoundation.org/QA/Bugzilla/Administration>`_ page for additional information
and examples about using Postgres to collect, condense, and analyze
information from the bug tracker. Content from that page and this
content will be refactored when it is added to the primary wiki docs.

Using Salt with our Bugzilla installation
-----------------------------------------

In general, we don't administer Bugzilla via salt, beyond the initial
setup of the machine. For more detailed information regarding Salt,
please see our `Salt Guide <http://wiki.documentfoundation.org/Infra/Guide to using Salt>`_ for anyone
who's new to using this tool, or who'd like more specifics on how we
use it internally at TDF.


Part 3: How to use our test VM for Bugzilla
===========================================

Alongside our primary production instance of Bugzilla, we maintain a
test VM (aka "bugzilla-test") as a shared workspace for QA to
investigate changes to any aspect of the bug tracker. Whenever we
consider new improvements such as adding access control to the
Severity and Priority fields, or work on routine maintenance, such as
upgrading to Bugzilla 5.0, we use this publicly-accessible server to
test and tweak patches before they reach production.

As a single, shared resource, proper coordination ensures that
different parties can work on different development projects without
collision. If the number of simultaneous projects increases, or if
people would like to conduct longer tests while using project
infrastructure, the possibility exists to spin-up additional test VMs
(bz-1, bz-2, etc..) for a limited duration.

Getting access
--------------

Access to the bugzilla-test VM is limited to QA developers. If you're
interested in authoring new improvements or helping test the result of
a system upgrade, please chat with `Robinson <http://wiki.documentfoundation.org/User:Qubit>`_ about your goals and experience, or join a weekly QA Meeting and introduce yourself.

After chatting with QA, an account can be created by one of our Sysadmins.

Logging in and connecting
-------------------------

Most of the TDF VMs have multiple entries in DNS. The internal
numbering entry (vm123, vm151, etc..) may change over time, so use the
full entry for ssh:

.. code-block:: bash

 ssh <username>@bugzilla-test.documentfoundation.org

Once logged-in, cd to the /srv/bugzilla/ directory. This is the home
directory for our 'bugzilla' user, and root of our Bugzilla install.

Git permission perils
---------------------

Because of the shared environment, it's easiest to keep permissions
and access control straight if all of the Bugzilla files are owned by
user 'bugzilla' (and group 'www-data'). If you don't log in directly
as the bugzilla user, please make sure to su to this user and/or run
all git commands using 'sudo -u', e.g:

.. code-block:: bash

    sudo -u bugzilla git remote update

If modifications are made by other user accounts  (e.g. updating git
as root, or adding text to a template file as a privileged user), then
some developers may be locked-out of editing or working with the git
repository.

*To Fix:* As root, cd to the Bugzilla install directory and fix ownership:

.. code-block:: bash

    chown -R bugzilla:www-data *

Coordinating shared development
-------------------------------

The test VM is a convenient environment in which to rapidly cycle
through different patches or variations on patches while testing with
multiple members of QA. Development can be collaborative and dynamic,
allowing us to arrive at a final decision much more quickly, with team
members actually involved in the overall process, and not just acting
like a rubber-stamp on a static change.

When all participants are working on the same fix or same patchset,
collaboration should be relatively straightforward. I'm not currently
aware of an appropriate collaborative/simultaneous editing tool such
as Etherpad that we could use to edit the source code, but as long as
everyone logs in as the bugzilla user and avoids overwriting each
others' code, shared changes are feasible.

How to commit changes from the VM
---------------------------------

Because all QA developers share a single git checkout and edit as the
same (bugzilla) user, authorship and blame for changes would not be
easily tracked were we to enable pushing directly from the running
repository.

There are multiple methods for commiting changes created on the VM:

Scp changes to your local machine
`````````````````````````````````

Perhaps the most complicated, it's always possible to copy the
changes, then commit and push locally. This strategy entails the most
overhead, but allows the most flexibility if you wish to split-up your
changes into multiple commits, perform further tests before pushing,
or make more sweeping changes.

Clone personal repository in home dir
`````````````````````````````````````

The TDF-Bugzilla repo is only 50 MB in size, so it's feasible to clone
a personal repository into your /home directory on the test VM.
Whenever you wish to make changes, sync-over the files from the
running repository, double-check to make sure you've excluded any
*test-VM*-specific config or other diffs, and then commit.

Right tools for testing
-----------------------

As a Perl-based web service, the most effective testing tools are a
mix of web browsers and a mix of OSes. If you don't have access to a
very diverse set of environments for testing, recruit people from
#libreoffice-qa and ask them to list what OSes and browsers they're
using to perform the tests.

Unless you are digging deep into the Bugzilla source code, most
changes will not require detailed code analysis. There are some useful
tools available, including a
`test suite <https://www.bugzilla.org/docs/developer.html#testsuite>`_
that you can run with your local checkout to verify your changes. For
extra points, consider adding a new unit test alongside any
significant improvements or changes to the code.

Differences between the test VM and production
----------------------------------------------

The Bugzilla production VM and test VM are very similar in most
aspects, but do have some relevant differences that may affect
testing, patches, etc.

* Because of the way in which we deploy via Salt, the running repository on the test VM does need small tweaks in data/params so that we use the correct base URLs.
* The test VM is typically provisioned with less CPU and RAM than production
* The test VM currently uses a very old copy of our Bugzilla database, with some information stripped-out. In the future, the database may become even simpler and smaller.

How might the differences affect patch behavior?
````````````````````````````````````````````````

There are few differences between the text VM and production that will
affect patch behavior. For any code that is dependent upon database
changes made after our Bugzilla migration (Jan 2015), the test VM may
not adequately exercise all aspects of the patch. Examples:

* new versions of LibreOffice
* additional added (or removed) products from the db
* changed data sets

Restoring snapshots of test VM
------------------------------

It's not currently possible to make or restore snapshots of the test
VM. We'll need to verify with the infra team whether we have the
overhead and tools accessible at this level to provide snapshotting
capabilities for this server.

Snapshotting a VM running on your local workstation is usually very
straightforward. Refer to the documentation for the product you're
using, for example:

* `Virtual Box <https://www.virtualbox.org/manual/ch01.html#snapshots>`_
* `VMWare <https://www.vmware.com/support/ws4/doc/preserve_snapshot_ws.html>`_
