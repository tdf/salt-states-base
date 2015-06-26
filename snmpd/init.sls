{% from "snmpd/map.jinja" import snmpd with context %}

snmpd:
  pkg:
    - installed
    - names:
      {% for pkg in snmpd['packages'] %}
      - {{ pkg }}
      {% endfor %}
  service:
    - running
    - name: {{ snmpd['service'] }}
    - enable: true
    - watch:
        - file: /etc/snmp/snmpd.conf
        - file: /etc/default/snmpd

/etc/snmp/snmpd.conf:
  file:
    - managed
    - source: salt://snmpd/snmpd.conf
    - mode: 0600
    - user: root
    - group: root
    - template: jinja
    - require:
        - pkg: snmpd

/etc/default/snmpd:
  file:
    - managed
    - name: {{ snmpd['defaults_file'] }}
    - source:
        - salt://snmpd/{{ snmpd.get('defaults_template', 'XXX') }}
        - salt://snmpd/default_snmpd.{{ grains['oscodename'] }}
    - user: root
    - group: root
    - require:
        - pkg: snmpd