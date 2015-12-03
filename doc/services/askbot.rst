.. index:: pair: service; askbot
.. index:: url; ask.libreoffice.org

.. _askbot_service:

Askbot
======

.. sectionauthor:: Alexander Werner <alex@documentfoundation.org>

Askbot is a stackoverflow-like Q&A-Forum and used for http://ask.libreoffice.org.



Installation
------------

.. note::

  Documentation for our instance can be found at http://ask.libreoffice.org/en/doc/index.html

* Install:

  * :doc:`nginx`
  * supervisord
  * Postgresql

* Allow to build ``psycopg2`` in a virtualenv::

    sudo apt-get build-dep python-psycopg2

* Create a user for askbot with group ``www-data`` and home directory :file:`/srv/askbot`::

    sudo useradd -md /srv/askbot -g www-data askbot

* Create database user::

    createuser -S -D -R -P askbot

* Clone the LibreOffice-Askbot Repository::

    sudo -i -u askbot
    git clone git@github.com:awerner/askbot-devel.git /srv/askbot/libo-askbot/

* Create a virtual python exclusively for askbot and install needed packages::

    sudo -i -u askbot
    virtualenv virt
    . virt/bin/activate
    pip install -r libo-askbot/askbot_requirements.txt
    pip install psycopg2
    pip install django-rosetta
    pip install uWSGI

* Adapt :file:`settings.py`:

  .. code-block:: python

    INTERNAL_IPS = ('127.0.0.1',)

    ADMINS = (
        ('Alexander Werner', 'alex@documentfoundation.org'),
    )

    MANAGERS = ADMINS

    DATABASE_ENGINE = 'postgresql_psycopg2'
    DATABASE_NAME = 'askbot'
    DATABASE_USER = 'askbot'
    DATABASE_PASSWORD = '******'
    DATABASE_HOST = 'localhost'
    DATABASE_PORT = ''

    SERVER_EMAIL = ''
    DEFAULT_FROM_EMAIL = 'webmaster@documentfoundation.org'
    EMAIL_HOST_USER = ''
    EMAIL_HOST_PASSWORD = ''
    EMAIL_SUBJECT_PREFIX = '[askLibO]'
    EMAIL_HOST='localhost'
    EMAIL_PORT='25'
    EMAIL_USE_TLS=False
    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

    TIME_ZONE = 'Europe/Berlin'

    LANGUAGE_CODE = 'en'

    LANGUAGES = (
      ('de', 'German'),
      ('en', 'English'),
      ('hr', 'Croatian'),
      ('it', 'Italian'),
      ('pt-br', 'Portugese'),
      ('sp', 'Spanish'),
      ('ro', 'Romanian'),
    )

    ASKBOT_ALLOWED_UPLOAD_FILE_TYPES = ('.jpg', '.jpeg', '.gif', '.bmp', '.png', '.tiff', '.odt', '.ods', '.odp', '.odg', '.odc', '.odf', '.odi', '.odm',
                                        '.ott', '.ots', '.otp', '.otg', '.odb')
    ASKBOT_MAX_UPLOAD_FILE_SIZE = 10 * 1024 * 1024 #result in bytes

    INSTALLED_APPS = (
        # .... +
        'avatar',#experimental use git clone git://github.com/ericflo/django-avatar.git$
        #requires setting of MEDIA_ROOT and MEDIA_URL
        'rosetta',
    )

    ASKBOT_URL = '' #no leading slash, default = '' empty string
    ASKBOT_TRANSLATE_URL = False #translate specific URLs

    CSRF_COOKIE_NAME = 'ask.libreoffice.org_csrf'
    CSRF_COOKIE_DOMAIN = DOMAIN_NAME

    RECAPTCHA_USE_SSL = True

* Collect static files::

    ./manage.py collectstatic

* Let ``supervisor`` manage the uWSGI-Processes, add to :file:`/etc/supervisord.conf`:

  .. code-block:: ini

    [program:uwsgi-askbot-emperor]
    command=/srv/askbot/virt/bin/uwsgi --emperor /srv/askbot/libo-askbot/uwsgi_config
    directory=/srv/askbot/
    user=askbot
    autorestart=true
    autostart=true
    redirect_stderr=true

* Restart supervisord / add ``uwsgi-askbot-emperor`` to supervisord.

* Basic nginx configuration in :file:`/etc/nginx/sites-enabled/askbot`:

  .. code-block:: nginx

    upstream askbot-en {
            server unix:///tmp/askbot-en.sock;
    }
    server {
            listen 80 default;
            client_max_body_size 4G;
            server_name ask.libreoffice.org;
            keepalive_timeout 5;
            # path for static files
            #root /srv/askbot/libo-askbot/static;
            location / {
              rewrite  ^(.*)$  /en$1  permanent;
            }
            location /static/ {
              location ~* ^.+\.(html|py) {
                deny all;
                return 404;
                break;
              }
              alias /srv/askbot/libo-askbot/static/;
              expires 30d;
            }
            location ^~ /upfiles/ {
              alias /srv/askbot/libo-askbot/askbot/upfiles/;
              expires 30d;
            }
            error_page 500 502 503 504  /500.html;
            location = /500.html {
              root  /var/www/maintenance/;
            }
            location /en/ {
                uwsgi_pass askbot-en;
                #uwsgi_param SCRIPT_NAME /en;
                include uwsgi_params;
            }
        }


Add translation
^^^^^^^^^^^^^^^
* Create a database for The language::

    createdb --template template0 --locale C.utf8 --encoding utf-8 --owner askbot askbot_LANGCODE

* Add the file :file:`settings_LANGCODE.py` in :file:`/srv/askbot/libo-askbot`:

  .. code-block:: python

    from settings import *
    _ = lambda x: x 

    #DEBUG = True
    #TEMPLATE_DEBUG = DEBUG
    DATABASE_NAME = 'askbot_LANGCODE'             # Or path to database file if using sqlite3.
    EMAIL_SUBJECT_PREFIX = '[askLibo-LANGCODE]'
    TIME_ZONE = 'ADAPT'
    LANGUAGE_CODE = 'LANGCODE'
    CACHE_PREFIX = 'askbot_LANGCODE'
    LOG_FILENAME = 'askbot_LANGCODE.log'
    ASKBOT_URL = 'LANGCODE/'
    LOGIN_URL = '/%s%s%s' % (ASKBOT_URL,_('account/'),_('signin/'))
    LOGIN_REDIRECT_URL = ASKBOT_URL
    CSRF_COOKIE_NAME = 'ask.libreoffice.org_LANGCODE_csrf'
    SESSION_COOKIE_PATH = '/%s' % ASKBOT_URL

* Add the file :file:`manage_LANGCODE.py` in :file:`/srv/askbot/libo-askbot`:

  .. code-block:: python

    #!/usr/bin/env python
    from django.core.management import execute_manager
    try:
        import settings_LANGCODE as settings # Assumed to be in the same directory.
    except ImportError:
        import sys
        sys.stderr.write("Error: Can't find the file 'settings.py' in the directory containing %r. It appears you've customized things.\nYou'll have to run django-admin.py, passing it your settings module.\n(If the file settings.py does indeed exist, it's causing an ImportError somehow.)\n" % __file__)
        sys.exit(1)

    if __name__ == "__main__":
        execute_manager(settings)

* Synchronize the new database::

    ./manage_LANGCODE.py syncdb --migrate

* Symlink :file:`/srv/askbot/libo-askbot/uwsgi_config/askbot.skel` to :file:`/srv/askbot/libo-askbot/uwsgi_config/LANGCODE.ini`::

    cd /srv/askbot/libo-asktob/uwsgi_config
    ln -s askbot.skel LANGCODE.ini

* Add nginx configuration to head of :file:`/etc/nginx/sites-enabled/askbot`:

  .. code-block:: nginx

    upstream askbot-LANGCODE {
            server unix:///tmp/askbot-LANGCODE.sock;
    }

* Add nginx configuration to the end of the ``server``-directive in :file:`/etc/nginx/sites-enabled/askbot`:

  .. code-block:: nginx

    location /en/ {
                  uwsgi_pass askbot-en;
                  #uwsgi_param SCRIPT_NAME /en;
                  include uwsgi_params;
              }


Error Handling
--------------

Service unavailable
^^^^^^^^^^^^^^^^^^^

* Do the sockets in :file:`/tmp/askbot-*` exist?

  * No:: 

     /etc/init.d/supervisord restart
  
  * Yes::

     /etc/init.d/supervisord stop
     rm /tmp/askbot-*
     /etc/init.d/supervisord start 




Start
-----

The askbot process is managed by supervisord::

  sudo supervisorctl start uwsgi-askbot-emperor



Stop
----

The askbot process is managed by supervisord::

  sudo supervisorctl stop uwsgi-askbot-emperor




Disable
-------

Set ``autostart=false`` in :file:`/etc/supervisord.conf` in the section ``program:uwsgi-askbot-emperor``



Enable
------

Set ``autostart=true`` in :file:`/etc/supervisord.conf` in the section ``program:uwsgi-askbot-emperor``




Responsible
-----------

Alexander Werner
