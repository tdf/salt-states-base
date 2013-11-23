libpq-dev:
  pkg:
    - installed

installed-packages-postgres-dev:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - libpq-dev
    - require_in:
      - file: /root/saltdoc/installed_packages.rst