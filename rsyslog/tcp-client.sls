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
      rsyslog_server: {{ pillar.get('rsyslog-tcp-server', 'loghost') }}
      rsyslog_port: {{ pillar.get('rsyslog-tcp-port', '514') }}
    - watch_in:
      - service: rsyslog
