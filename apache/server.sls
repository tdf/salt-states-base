apache2-pkg:
  pkg:
    - installed
    - names:
      - apache2-mpm-prefork

apache2:
  service:
    - running
    - enabled: true    
    - reload: true
    - require:
      - pkg: apache2-mpm-prefork
    - watch:
      - pkg: apache2-mpm-prefork

www-data:
  alias.present:
    - target: root

/etc/apache2/conf.d/localized-error-pages:
  file.managed:
    - source: salt://apache/localized-error-pages
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: apache2

/var/www/index.html:
  file.absent

/srv/www:
  file.directory:
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 0755

{% for mod in ['include', 'proxy_http', 'rewrite', 'ssl', 'expires'] %}
a2enmod {{mod}}:
  cmd.run:
    - unless: test -f /etc/apache2/mods-enabled/{{mod}}.load
    - watch_in:
      - service: apache2
{% endfor %}

/etc/apache2/conf.d/security_servertoken:
  file.sed:
    - name: /etc/apache2/conf.d/security
    - before: '^ServerTokens OS$'
    - after: 'ServerTokens Prod'
    - watch_in:
      - service: apache2

/etc/apache2/conf.d/security_serversignature:
  file.sed:
    - name: /etc/apache2/conf.d/security
    - before: '^ServerSignature On$'
    - after: 'ServerSignature Off'
    - watch_in:
      - service: apache2

/etc/apache2/mods-available/alias.conf:
  file.sed:
    - before: '^Options Indexes MultiViews$'
    - after: 'Options -Indexes MultiViews'
    - watch_in:
      - service: apache2

/etc/apache2/conf.d/z99-user:
  file.managed:
    - source: salt://apache/z99-user
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - service: apache2