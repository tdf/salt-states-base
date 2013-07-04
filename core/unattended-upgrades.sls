unattended-upgrades:
  pkg.installed:
    - debconf: salt://debconf/unattended-upgrades
