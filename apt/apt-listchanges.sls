# Installs apt-listchanges package for notifieing on package updates
apt-listchanges:
  pkg.installed:
    - debconf: salt://debconf/apt-listchanges
