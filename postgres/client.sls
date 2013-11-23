# installs postgresql client
postgresql-client:
  pkg.installed


installed-packages-postgres-client:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - postgresql-client
    - require_in:
      - file: /root/saltdoc/installed_packages.rst