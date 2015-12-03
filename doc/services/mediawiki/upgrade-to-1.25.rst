.. index:: pair: service; wiki; mediawiki
.. index:: url; wiki.documentfoundation.org


Upgrade MediaWiki to version 1.25
=================================

.. sectionauthor:: Dennis Roczek <dennisroczek@libreoffice.org>

This is an guide to install Mediawiki 1.25. Many stuff has changed and this is more a todo list for me to remember what has to be changed. This is especially important for extensions as the complete registration system has changed.


Dependencies
------------

We do need to have the following installed (resolved stuff will be removed)

* PHP 5.3


General changes to LocalSettings.php
------------------------------------
Replace all require_once to wfLoadExtension (?!? - evaluate!)
Replace all require_once to wfLoadSkin fot the vector skins
after switching branch AddHTMLMetaAndTitle, fix LocalSetting.php

remove $wgDisableCounters as it was removed.

Extension:Cite
--------------
https://www.mediawiki.org/wiki/Extension:Cite

Remove require_once "$IP2/extensions/Cite/specialCite.php"; from our LocalSettings.php

Remove the extension folder at /var/www/sites/wiki.documentfoundation.org/extensions/Cite.


Extension: OpenSearchXml
------------------------
This extension is integrated in Mediawiki 1.25 :-) Please deinstall it after upgrading.
also remove the folder + the require_once in the LocalSettings.php

