include:
  - rsyslog.rsyslog
 
/etc/rsyslog.d/udp-client.conf:
  file.managed:
    - source: salt://rsyslog/udp-client.conf
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
      syslog_server: {{ pillar.get('rsyslog-udp-server', '') }}
    - watch_in:
      - service: rsyslog
