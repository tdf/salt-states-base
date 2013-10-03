include:
  - rsyslog.rsyslog
 
/etc/rsyslog.d/tcp-client.conf:
  file.managed:
    - source: salt://rsyslog/tcp-client.conf
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
      syslog_server: {{ pillar.get('rsyslog-tcp-server', '') }}
    - watch_in:
      - service: rsyslog
