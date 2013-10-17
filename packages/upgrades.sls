# installs and configures unattended-upgrades
unattended-upgrades:
  pkg.installed:
    - debconf: salt://packages/upgrades.debconf
