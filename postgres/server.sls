# define postgresql service and installs needed postgresql pakages
postgresql:
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: postgresql
    - watch:
      - pkg: postgresql
  pkg:
    - installed

installed-packages-postgres-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - postgresql
    - require_in:
      - file: /root/saltdoc/installed_packages.rst