# installs apache2 packages and defines service for apache
include:
  - requisites

apache2:
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: apache2
    - watch:
      - pkg: apache2
  pkg:
    - installed
    - name: apache2-mpm-prefork

# create alias from www-data to root in aliases
www-data:
  alias.present:
    - target: root

# overwrites localized-error-pages with default configuration
/etc/apache2/conf.d/localized-error-pages:
  file.managed:
    - source: salt://apache/localized-error-pages
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: apache2

# removed /var/www/index.html
/var/www/index.html:
  file.absent

# created /srv/www directory
/srv/www:
  file.directory:
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 0755
    - require:
      - pkg: apache2

# enables apache2 modules
{% for mod in ['include', 'proxy_http', 'rewrite', 'ssl', 'expires'] %}
a2enmod {{mod}}:
  cmd.run:
    - unless: test -f /etc/apache2/mods-enabled/{{mod}}.load
    - watch_in:
      - service: apache2
{% endfor %}

# sets ServerTokens Prod in apache config
/etc/apache2/conf.d/security_servertoken:
  file.sed:
    - name: /etc/apache2/conf.d/security
    - before: '^ServerTokens OS$'
    - after: 'ServerTokens Prod'
    - watch_in:
      - service: apache2

# sets ServerSignature Off in apache config
/etc/apache2/conf.d/security_serversignature:
  file.sed:
    - name: /etc/apache2/conf.d/security
    - before: '^ServerSignature On$'
    - after: 'ServerSignature Off'
    - watch_in:
      - service: apache2

# Disabling Indexing
/etc/apache2/mods-available/alias.conf:
  file.sed:
    - before: '^Options Indexes MultiViews$'
    - after: 'Options -Indexes MultiViews'
    - watch_in:
      - service: apache2

# Creates user-config for apache
/etc/apache2/conf.d/z99-user:
  file.managed:
    - source: salt://apache/z99-user
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: apache2

installed-packages-apache-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - apache2-mpm-prefork
    - require_in:
      - file: /root/saltdoc/installed_packages.rst