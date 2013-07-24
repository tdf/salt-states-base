include:
  - apache.server

libapache2-mod-macro:
  pkg:
    - installed
    - watch_in:
      - service: apache2

{% for mod in ['macro'] %}
a2enmod {{mod}}:
  cmd.run:
    - unless: test -f /etc/apache2/mods-enabled/{{mod}}.load
    - require:
      - pkg: libapache2-mod-macro
    - watch_in:
      - service: apache2
{% endfor %}

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