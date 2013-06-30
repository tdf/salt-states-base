console-setup_debconf:
  debconf.set_file:
    - source: salt://debconf/console-setup

dpkg-reconfigure -u console-setup:
  cmd.wait:
    - watch:
      - debconf: console-setup_debconf

