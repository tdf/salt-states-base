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
      rsyslog_server: {{ pillar.get('rsyslog-udp-server', 'loghost') }}
      rsyslog_port: {{ pillar.get('rsyslog-udp-port', '514') }}
    - watch_in:
      - service: rsyslog
