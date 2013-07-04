squid3:
  service:
    - running
    - enabled: true    
    - reload: true
    - require:
      - pkg: squid3
    - watch:
      - pkg: squid3
  pkg:
    - installed
