{% from "mail/map.jinja" import mail with context %}
{% set nullmailer = salt['pillar.get']('mail:nullmailer', True) %}
{% set authorized_submit_users = salt['pillar.get']('mail:authorized_submit_users', 'root') %}
{% set mydomains = salt['pillar.get']('mail:mydomains', [grains['fqdn'],]) %}
{% set relayhost = salt['pillar.get']('mail:relayhost', False) %}
{% set users = salt['pillar.get']('mail:users', {'root@'+grains['fqdn']: {'name': 'root'}}) %}

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
    - mode: 0644
    - source: salt://mail/conf/postfix/transports
    - template: jinja
    - context:
      mydomains: {{ mydomains }}
  cmd:
    - wait
    - name: postmap /etc/postfix/transports
    - watch:
      - file: /etc/postfix/transports

/etc/postfix/recipients:
  file:
    - managed
    - user: root
    - group: postfix
    - mode: 0644
    - source: salt://mail/conf/postfix/recipients
    - template: jinja
    - context:
      users: {{ users }}
  cmd:
    - wait
    - name: postmap /etc/postfix/recipients
    - watch:
      - file: /etc/postfix/recipients

dovecot:
  pkg:
    - installed
    - names:
      {% for package in mail.dovecot_packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - user: vmail
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

/etc/dovecot/conf.d/10-auth.conf:
  file:
    - managed
    - source: salt://mail/conf/dovecot/10-auth.conf
    - watch_in:
      - service: dovecot

/etc/dovecot/conf.d/10-mail.conf:
  file:
    - managed
    - source: salt://mail/conf/dovecot/10-mail.conf
    - watch_in:
      - service: dovecot

/etc/dovecot/users:
  file:
    - managed
    - source: salt://mail/conf/dovecot/users
    - template: jinja
    - context:
      users: {{ users }}
    - watch_in:
      - service: dovecot

/usr/local/sbin/mkdrop:
  file:
    - managed
    - source: salt://mail/scripts/mkdrop
    - mode: 0755
  cmd.wait:
    - watch:
      - file: /usr/local/sbin/mkdrop

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://mail/conf/postfix/master.cf

vmail:
  user:
    - present
    - fullname: Virtual Mail User
    - shell: /bin/bash
    - home: /srv/mail
    - uid: 2000
    - gid: 2000
    - system: True
    - require:
      - group: vmail
  group:
    - present
    - gid: 2000
    - system: True
{% endif %}