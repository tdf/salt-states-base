include:
  - requisites

# Installs apt-listchanges package for notifieing on package updates
apt-listchanges:
  pkg.installed:
    - debconf: salt://apt/apt-listchanges

installed-packages-apt-listchanges:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - apt-listchanges
    - require_in:
      - file: /root/saltdoc/installed_packages.rst