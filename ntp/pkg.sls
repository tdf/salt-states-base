# installs and manage service for ntp
ntp:
  service:
    - running
    - require:
      - pkg: ntp
    - watch:
      - pkg: ntp
  pkg:
    - installed
    - names:
      - ntp
      - ntpdate

installed-packages-ntp-pkg:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - ntp
    - require_in:
      - file: /root/saltdoc/installed_packages.rst