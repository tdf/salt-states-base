{% from "postgres/map.jinja" import postgres with context %}

libpq-dev:
  pkg:
    - {{ postgres.dev }}

installed-packages-postgres-dev:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ postgres.dev }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst