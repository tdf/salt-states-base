# installs sudo
sudo:
  pkg.installed

# manages sudoers
/etc/sudoers:
    file.managed:
     - source: salt://util/sudoers
     - user: root
     - group: root
     - mode: 0440
     - require:
       - pkg: sudo
