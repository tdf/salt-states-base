uwsgi:
  pkg:
    - installed
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: uwsgi
    - watch:
      - pkg: uwsgi