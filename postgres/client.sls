{% from "postgres/map.jinja" import postgres with context %}

# installs postgresql client
postgresql-client:
  pkg.installed:
    - name: {{ postgres.client }}


installed-packages-postgres-client:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ postgres.client }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst