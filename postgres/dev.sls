{% from "postgres/map.jinja" import postgres with context %}
include:
  - requisites

libpq-dev:
  pkg:
    - installed
    - name: {{ postgres.dev }}

installed-packages-postgres-dev:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ postgres.dev }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst