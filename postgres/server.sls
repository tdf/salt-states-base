# define postgresql service and installs needed postgresql pakages
postgresql:
  service.running:
    - enabled: true
    - require:
      - pkg: postgresql-server
    - watch:
      - pkg: postgresql-server
      - file: /etc/postgresql/9.1/main/postgresql.conf
  pkg.installed:
    - names:
      - postgresql-server

# watches file for config changes
/etc/postgresql/9.1/main/postgresql.conf:
  file.managed:
    - watch_in:
      - service: postgres

# watches file for config changes
/etc/postgresql/9.1/main/environment:
  file.managed:
    - watch_in:
      - service: postgres

# watches file for config changes
/etc/postgresql/9.1/main/pg_hba.conf:
  file.managed:
    - watch_in:
      - service: postgres

# watches file for config changes
/etc/postgresql/9.1/main/pg_ident.conf:
  file.managed:
    - watch_in:
      - service: postgres

# watches file for config changes
/etc/postgresql/9.1/main/start.conf:
  file.managed:
    - watch_in:
      - service: postgres
