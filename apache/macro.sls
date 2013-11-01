# includes apache.server as Dependencie
include:
  - apache.server
  - requisites

# installs apache-module macro
libapache2-mod-macro:
  pkg:
    - installed
    - watch_in:
      - service: apache2

# enables apache-module macro in apache
{% for mod in ['macro'] %}
a2enmod {{mod}}:
  cmd.run:
    - unless: test -f /etc/apache2/mods-enabled/{{mod}}.load
    - require:
      - pkg: libapache2-mod-macro
    - watch_in:
      - service: apache2
{% endfor %}

# creates apache macro template for creating many vhosts.
# The templates can be used to create vhosts in apache
/etc/apache2/conf.d/TEMPLATE.VHost:
  file.managed:
    - source: salt://apache/TEMPLATE.VHost
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: libapache2-mod-macro
    - watch_in:
      - service: apache2

installed-packages-apache-macro:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - libapache2-mod-macro
    - require_in:
      - file: /root/saltdoc/installed_packages.rst