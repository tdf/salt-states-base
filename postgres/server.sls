postgresql-server:
  pkg.installed:
    - name: postgresql

postgresql:
  service.running:
    - enabled: true
    - require:
      - pkg: postgresql-server
    - watch:
      - pkg: postgresql-server
      - file: /etc/postgresql/9.1/main/postgresql.conf
      - file: /etc/postgresql/9.1/main/environment
      - file: /etc/postgresql/9.1/main/pg_hba.conf
      - file: /etc/postgresql/9.1/main/pg_ident.conf
      - file: /etc/postgresql/9.1/main/start.conf

/etc/postgresql/9.1/main/postgresql.conf:
  file.managed

/etc/postgresql/9.1/main/environment:
  file.managed

/etc/postgresql/9.1/main/pg_hba.conf:
  file.managed

/etc/postgresql/9.1/main/pg_ident.conf:
  file.managed

/etc/postgresql/9.1/main/start.conf:
  file.managed