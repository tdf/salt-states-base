# includes installation of debconf-utils
include:
  - core.debconf

# definition of sonsole-setup to configure console-setup
console-setup_debconf:
  debconf.set_file:
    - source: salt://console/console-setup
    - require:
      - pkg: debconf-utils

# do the package-configuration of console-setup
dpkg-reconfigure -u console-setup:
  cmd.wait:
    - watch:
      - debconf: console-setup_debconf
