include:
  - uwsgi

uwsgi-plugin-python:
  pkg.installed:
    - require:
        - pkg: uwsgi
    - watch_in:
        - service: uwsgi