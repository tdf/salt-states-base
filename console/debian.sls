{% if grains['os_family'] == 'Debian' %}

# includes installation of debconf-utils
include:
  - debian.debconf

console-setup:
  pkg:
    - installed
    - debconf: salt://console/console-setup

# definition of sonsole-setup to configure console-setup
console-setup_debconf:
  debconf.set_file:
    - source: salt://console/console-setup
    - require:
      - pkg: debconf-utils
      - pkg: console-setup

# do the package-configuration of console-setup
dpkg-reconfigure -u console-setup:
  cmd.wait:
    - watch:
      - debconf: console-setup_debconf


installed-packages-console-setup:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - console-setup
    - require_in:
      - file: /root/saltdoc/installed_packages.rst


{% endif %}
