include:
  - rsyslog.rsyslog
 
/etc/rsyslog.d/tcp-server.conf:
  file.managed:
    - source: salt://rsyslog/tcp-server.conf
    - user: root
    - group: root
    - mode: 0644
    - context:
      rsyslog_port: {{ pillar.get('rsyslog-tcp-port', '514') }}
    - watch_in:
      - service: rsyslog

