{% from "postgres/map.jinja" import postgres with context %}

include:
  - requisites

# define postgresql service and installs needed postgresql pakages
postgresql:
  service:
    - running
    - name: {{ postgres.service }}
    - enable: true    
    - reload: true
    - require:
      - pkg: postgresql
  pkg:
    - installed
    - name: {{ postgres.server }}

installed-packages-postgres-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ postgres.server }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst

installed-services-postgres-server:
  file.accumulated:
    - name: installed_services
    - filename: /root/saltdoc/installed_services.rst
    - text:
      - {{ postgres.service }}
    - require_in:
      - file: /root/saltdoc/installed_services.rst