# installs and configures unattended-upgrades

include:
  - requisites

unattended-upgrades:
  pkg.installed:
    - debconf: salt://packages/upgrades.debconf

installed-packages-packages-upgrades:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - unattended-upgrades
    - require_in:
      - file: /root/saltdoc/installed_packages.rst