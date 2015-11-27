{% from "mail/map.jinja" import mail with context %}
{% set nullmailer = salt['pillar.get']('mail:nullmailer', True) %}
{% set authorized_submit_users = salt['pillar.get']('mail:authorized_submit_users', 'root') %}
{% set mydomains = salt['pillar.get']('mail:mydomains', [grains['fqdn'],]) %}
{% set relayhost = salt['pillar.get']('mail:relayhost', False) %}
{% set users = salt['pillar.get']('mail:users', {'root@'+grains['fqdn']: {'name': 'root'}}) %}
{% set valid_senders = salt['pillar.get']('mail:valid_senders', {}) %}

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

cleanup_defaults:
  cmd:
    - run
    - name: rm -rf /etc/postfix/main.cf /etc/postfix/master.cf /etc/default/amavisd-milter /etc/clamav/clamd.conf ; touch /etc/postfix/.cleaned
    - unless: test -f /etc/postfix/.cleaned
    - require:
      - pkg: postfix
      {% if not nullmailer %}
      - pkg: amavis
      {% endif %}

/etc/postfix/main.cf:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/main.cf
    - template: jinja
    - require:
      - file: /etc/postfix/main.cf_mode
    - watch_in:
      - service: postfix
    - context:
        nullmailer: {{ nullmailer }}
        relayhost: {{ relayhost }}

/etc/postfix/main.cf_mode:
  file:
    - managed
    - name: /etc/postfix/main.cf
    - require: 
      - pkg: postfix
      - cmd: cleanup_defaults

{% if not nullmailer %}
postfix_cdb:
  pkg:
    - installed
    - name: {{ mail.postfix_cdb_package }}

postfix_pcre:
  pkg:
    - installed
    - name: {{ mail.postfix_pcre_package }}

/etc/postfix/transports:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/transports
    - template: jinja
    - context:
        mydomains: {{ mydomains }}
    - require:
      - file: /etc/postfix/transports_mode
  cmd:
    - wait
    - name: postmap /etc/postfix/transports
    - watch:
      - file: /etc/postfix/transports

/etc/postfix/transports_mode:
  file:
    - managed
    - name: /etc/postfix/transports
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/recipients:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/recipients
    - template: jinja
    - context:
        users: {{ users }}
    - require:
      - file: /etc/postfix/recipients_mode
  cmd:
    - wait
    - name: postmap /etc/postfix/recipients
    - watch:
      - file: /etc/postfix/recipients

/etc/postfix/recipients_mode:
  file:
    - managed
    - name: /etc/postfix/recipients
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/client_access:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/client_access
    - require:
      - file: /etc/postfix/client_access_mode
  cmd:
    - wait
    - name: postmap /etc/postfix/client_access
    - watch:
      - file: /etc/postfix/client_access

/etc/postfix/client_access_mode:
  file:
    - managed
    - name: /etc/postfix/client_access
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/helo_access:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/helo_access
    - require:
      - file: /etc/postfix/helo_access_mode


/etc/postfix/helo_access_mode:
  file:
    - managed
    - name: /etc/postfix/helo_access
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/identity_abuse:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/identity_abuse
    - require:
      - file: /etc/postfix/identity_abuse_mode

/etc/postfix/identity_abuse_mode:
  file:
    - managed
    - name: /etc/postfix/identity_abuse
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/postscreen_access:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/postscreen_access
    - require:
      - file: /etc/postfix/postscreen_access_mode

/etc/postfix/postscreen_access_mode:
  file:
    - managed
    - name: /etc/postfix/postscreen_access
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/roles:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/roles
    - require:
      - file: /etc/postfix/roles_mode
  cmd:
    - wait
    - name: postmap /etc/postfix/roles
    - watch:
      - file: /etc/postfix/roles

/etc/postfix/roles_mode:
  file:
    - managed
    - name: /etc/postfix/roles
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

/etc/postfix/rbl_exceptions:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/rbl_exceptions
    - require:
      - file: /etc/postfix/rbl_exceptions_mode
  cmd:
    - wait
    - name: postmap /etc/postfix/rbl_exceptions
    - watch:
      - file: /etc/postfix/rbl_exceptions

/etc/postfix/rbl_exceptions_mode:
  file:
    - managed
    - name: /etc/postfix/rbl_exceptions
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults
        
/etc/postfix/valid_senders:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/valid_senders
    - template: jinja
    - require:
      - file: /etc/postfix/valid_senders_mode
    - context:
        users: {{ users }}
        valid_senders: {{ valid_senders }}
  cmd:
    - wait
    - name: postmap /etc/postfix/valid_senders
    - watch:
      - file: /etc/postfix/valid_senders

/etc/postfix/valid_senders_mode:
  file:
    - managed
    - name: /etc/postfix/valid_senders
    - user: root
    - group: postfix
    - mode: 0644
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

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
    - require:
      - pkg: dovecot

/etc/dovecot/conf.d/10-auth.conf:
  file:
    - managed
    - source: salt://mail/conf/dovecot/10-auth.conf
    - watch_in:
      - service: dovecot
    - require:
      - pkg: dovecot

/etc/dovecot/conf.d/10-mail.conf:
  file:
    - managed
    - source: salt://mail/conf/dovecot/10-mail.conf
    - watch_in:
      - service: dovecot
    - require:
      - pkg: dovecot

/etc/dovecot/users:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/dovecot/users
    - template: jinja
    - context:
        users: {{ users }}
    - watch_in:
      - service: dovecot
    - require:
      - file: /etc/dovecot/users_mode

/etc/dovecot/users_mode:
  file:
    - mode
    - name: /etc/dovecot/users
    - require:
      - pkg: dovecot
      - cmd: cleanup_defaults

/usr/local/sbin/mkdrop:
  file:
    - managed
    - source: salt://mail/scripts/mkdrop
    - mode: 0755
  cmd:
    - run
    - creates: /etc/postfix/drop
    - require:
      - file: /usr/local/sbin/mkdrop
  # todo: mkdrop as cronjob

/etc/postfix/master.cf:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/postfix/master.cf
    - require:
      - file: /etc/postfix/master.cf_mode
    - watch_in:
      - service: postfix

/etc/postfix/master.cf_mode:
  file:
    - managed
    - name: /etc/postfix/master.cf
    - require:
      - pkg: postfix
      - cmd: cleanup_defaults

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

amavis:
  pkg:
    - installed
    - names: {{ mail.amavis_packages }}
  service:
    - running
    - enable: True
    - name: {{ mail.amavis_service }}
    - require:
      - pkg: amavis

amavisd-milter:
  service:
    - running
    - enable: True
    - name: {{ mail.amavis_milter_service }}
    - require:
      - pkg: amavis

clamav:
  group:
    - present
    - addusers:
      - amavis
    - require:
      - pkg: amavis
  service:
    - running
    - enable: True
    - name: {{ mail.clamav_service }}
    - require:
      - pkg: amavis

/etc/default/amavisd-milter:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/amavis/amavisd-milter
    - require:
      - file: /etc/default/amavisd-milter_mode
    - watch_in:
      - service: amavisd-milter
      - service: amavis

/etc/default/amavisd-milter_mode:
  file:
    - managed
    - name: /etc/default/amavisd-milter
    - require:
      - pkg: amavis
      - cmd: cleanup_defaults

/etc/amavis/conf.d/60-local:
  file:
    - managed
    - source: salt://mail/conf/amavis/60-local
    - template: jinja
    - context:
        fqdn: {{ grains['fqdn']}}
        domain: {{ grains['domain'] }}
    - watch_in:
      - service: amavis
      - service: amavisd-milter

/etc/clamav/clamd.conf:
  file:
    - blockreplace
    - append_if_not_found: True
    - source: salt://mail/conf/clamav/clamd.conf
    - require: 
      - file: /etc/clamav/clamd.conf_mode
    - watch_in:
      - service: clamav

/etc/clamav/clamd.conf_mode:
  file:
    - managed
    - name: /etc/clamav/clamd.conf
    - require:
      - pkg: amavis
      - cmd: cleanup_defaults
{% endif %}