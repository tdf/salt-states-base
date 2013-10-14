include:
  - rsyslog.rsyslog
 
/etc/rsyslog.d/udp-server.conf:
  file.managed:
    - source: salt://rsyslog/udp-server.conf
    - user: root
    - group: root
    - mode: 0644
    - context:
      rsyslog_port: {{ pillar.get('rsyslog-udp-port', '514') }}
    - watch_in:
      - service: rsyslog
