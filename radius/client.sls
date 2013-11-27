# installs the freeradius-utils
radius-client:
  pkg.installed:
    - name: freeradius-utils


installed-packages-radius-client:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - freeradius-utils
    - require_in:
      - file: /root/saltdoc/installed_packages.rst