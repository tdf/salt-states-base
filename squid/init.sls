# installs squid3 and defines service
squid3:
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: squid3
    - watch:
      - pkg: squid3
  pkg:
    - installed
