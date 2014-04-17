shorewall:
  pkg:
    - installed
    - names:
      - shorewall
      - shorewall6
  service:
    - running
    - enable: True
    - require:
        - pkg: shorewall
    - watch:
        - file: /etc/default/shorewall

/etc/default/shorewall:
  file:
    - managed
    - source: salt://shorewall/default_shorewall.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}