apticron:
  pkg.installed:
    - debconf: salt://debconf/apticron

/etc/apticron/apticron.conf:
  file.sed:
    - before: '^#*\s*LISTCHANGES_PROFILE\s*=\s*.*$'
    - after: 'LISTCHANGES_PROFILE="apticron"'
    - require:
      - pkg: apticron
      - pkg: debconf-utils

