fail2ban:
  pkg: 
    - installed
  service:
    - running
    - enable: True

/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://fail2ban/jail.local
    - user: root
    - group: root
    - mode: 644
    - watch_in:
       - service: fail2ban
    - require:
       - pkg: fail2ban
