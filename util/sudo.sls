sudo:
  pkg.installed

/etc/sudoers:
    file.managed:
     - source: salt://core/sudoers
     - user: root
     - group: root
     - mode: 0440
     - require:
       - pkg: sudo
