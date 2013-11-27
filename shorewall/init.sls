shorewall:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
        - pkg: shorewall
