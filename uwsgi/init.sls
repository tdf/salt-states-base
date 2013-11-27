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

installed-packages-uwsgi:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - uwsgi
    - require_in:
      - file: /root/saltdoc/installed_packages.rst