# installs screen
screen:
  pkg.installed

# manages screenrc using predefined values
/etc/screenrc:
    file.managed:
     - source: salt://util/screenrc
     - user: root
     - group: root
     - mode: 0644
     - require:
       - pkg: screen
