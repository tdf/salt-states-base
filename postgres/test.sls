include:
  - postgres
  
can connect to postgresql socket as user postgres:
  cmd:
    - run
    - name: psql -c"\conninfo"
    - user: postgres
    - require:
        - service: postgresql