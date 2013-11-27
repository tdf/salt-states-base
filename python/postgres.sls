include:
  - python

psycopg2:
  pkg:
    - installed
    - name: python-psycopg2


installed-packages-python-postgres:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - python-psycopg2
    - require_in:
      - file: /root/saltdoc/installed_packages.rst