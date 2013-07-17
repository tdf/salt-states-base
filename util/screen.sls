screen:
  pkg.installed

/etc/screenrc:
    file.managed:
     - source: salt://core/screenrc
     - user: root
     - group: root
     - mode: 0644
     - require:
       - pkg: screen
