# installs apticron for automatically installs updates
apticron:
  pkg.installed:
    - debconf: salt://debconf/apticron

# configuring apticron
/etc/apticron/apticron.conf:
  file.sed:
    - before: '^#*\s*LISTCHANGES_PROFILE\s*=\s*.*$'
    - after: 'LISTCHANGES_PROFILE="apticron"'
    - require:
      - pkg: apticron
      - pkg: debconf-utils
