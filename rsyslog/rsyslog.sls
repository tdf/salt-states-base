rsyslog:
  service:
    - running
    - enable: true    
    - reload: false
    - require:
      - pkg: rsyslog
    - watch:
      - pkg: rsyslog
  pkg:
    - installed

