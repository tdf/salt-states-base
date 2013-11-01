include:
  - requisites

# installs apticron for automatically installs updates
apticron:
  pkg.installed:
    - debconf: salt://apt/apticron

# configuring apticron
/etc/apticron/apticron.conf:
  file.sed:
    - before: '^#*\s*LISTCHANGES_PROFILE\s*=\s*.*$'
    - after: 'LISTCHANGES_PROFILE="apticron"'
    - require:
      - pkg: apticron
      - pkg: debconf-utils


installed-packages-apt-apticron:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - apticron
    - require_in:
      - file: /root/saltdoc/installed_packages.rst