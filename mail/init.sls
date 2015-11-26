{% from "mail/map.jinja" import mail with context %}
{% set nullmailer = salt['pillar.get']('mail:nullmailer', True) %}
{% set authorized_submit_users = salt['pillar.get']('mail:authorized_submit_users', 'root') %}
{% set mydomains = salt['pillar.get']('mail:mydomains', [grains['fqdn'],]) %}
{% set relayhost = salt['pillar.get']('mail:relayhost', False) %}

include:
  - requisites

postfix:
  service:
    - running
    - name: {{ mail.postfix_service }}
    - enable: true    
    - reload: true
    - require:
      - pkg: postfix
    - watch:
      - pkg: postfix
  pkg:
    - installed
    - name: {{ mail.postfix_package }}


/etc/postfix/main.cf:
  file:
    - managed
    - source: salt://mail/conf/postfix/main.cf
    - template: jinja
    - watch_in:
      - service: postfix
    - context:
      nullmailer: {{ nullmailer }}
      relayhost: {{ relayhost }}

{% if not nullmailer %}
postfix_cdb:
  pkg:
    - installed
    - name: {{ mail.postfix_cdb_package }}

/etc/postfix/transports:
  file:
    - managed
    - user: root
    - group: postfix
    - chmod: 640
    - source: salt://mail/conf/postfix/transports
    - template: jinja
    - context:
      mydomains: {{ mydomains }}
  cmd:
    - wait
    - name: postmap /etc/postfix/transports
    - watch:
      - file: /etc/postfix/transports

/etc/postfix/relaydomains:
  file:
    - managed
    - user: root
    - group: postfix
    - chmod: 640
    - source: salt://mail/conf/postfix/relaydomains
    - template: jinja
    - context:
      mydomains: {{ mydomains }}
  cmd:
    - wait
    - name: postmap /etc/postfix/relaydomains
    - watch:
      - file: /etc/postfix/relaydomains

dovecot:
  pkg:
    - installed
    - names:
      {% for package in mail.dovecot_packages %}
      - {{ package }}
      {% endfor %}
  service:
    - running
    - name: {{ mail.dovecot_service }}
    - enable: True

/etc/dovecot/conf.d/10-master.conf:
  file:
    - managed
    - source: salt://mail/conf/dovecot/10-master.conf
    - watch_in:
      - service: dovecot
{% endif %}