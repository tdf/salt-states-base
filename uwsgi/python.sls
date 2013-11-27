include:
  - uwsgi

uwsgi-plugin-python:
  pkg.installed:
    - require:
        - pkg: uwsgi
    - watch_in:
        - service: uwsgi

installed-packages-uwsgi-python:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - uwsgi-plugin-python
    - require_in:
      - file: /root/saltdoc/installed_packages.rst