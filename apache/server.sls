{% from "apache/map.jinja" import apache with context %}

# installs apache2 packages and defines service for apache
include:
  - requisites

apache2:
  service:
    - running
    - name: {{ apache.service }}
    - enable: true    
    - reload: true
    - require:
      - pkg: apache2
    - watch:
      - pkg: apache2
  pkg:
    - installed
    - name: {{ apache.server }}

{% set alias = salt['pillar.get']('apache:alias', 'root') %} # '
{% if alias %}
# defines mail-alias from www-data to root
{{ apache.user }}:
  alias.present:
    - target: {{ alias }}
{% endif %}

# overwrites localized-error-pages with default configuration
apache-localized-error-pages:
  file.managed:
    - source: salt://apache/localized-error-pages
    - name: {{ apache.conf-dir }}/localized-error-pages
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
    - user: {{ apache.user }}
    - group: {{ apache.group }}
    - mode: 0755
    - require:
      - pkg: apache2

# ####################################################
# TODO: move to modules.sls and make list configurable
# enables apache2 modules
{% for mod in ['include', 'proxy_http', 'rewrite', 'ssl', 'expires'] %}
a2enmod {{mod}}:
  cmd.run:
    - unless: test -f /etc/apache2/mods-enabled/{{mod}}.load
    - watch_in:
      - service: apache2
{% endfor %}
# ####################################################

# #####################################################
# TOOD: Replace whole configuration file instead of sed
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
# #####################################################


# #####################################################
# TODO: move to apache/mods/alias.sls, make configurable

# Disabling Indexing
/etc/apache2/mods-available/alias.conf:
  file.sed:
    - before: '^Options Indexes MultiViews$'
    - after: 'Options -Indexes MultiViews'
    - watch_in:
      - service: apache2
# #####################################################


# # #####################################################
# TODO: Make configurable, use more explicit name
# Creates user-config for apache
/etc/apache2/conf.d/z99-user:
  file.managed:
    - source: salt://apache/z99-user
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: apache2
# #####################################################

installed-services-apache-server:
  file.accumulated:
    - name: installed_services
    - filename: /root/saltdoc/installed_services.rst
    - text:
      - {{ apache.service }}
    - require_in:
      - file: /root/saltdoc/installed_services.rst

installed-packages-apache-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ apache.server }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
