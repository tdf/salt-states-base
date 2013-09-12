include:
  - postgres
  - postgres.dev
  - python
  - python.dev
  - supervisor
  - nginx

/srv/sentry/:
  virtualenv.managed:
    - system_site_packages: False
    - runas: sentry
    - require:
        - pkg: virtualenv
        - user: sentry
  file:
    - directory
    - user: sentry
    - group: sentry
    - recurse:
        - user
        - group
    - require:
        - user: sentry

sentry-psycopg2:
  pip:
    - installed
    - name: psycopg2==2.5.1
    - bin_env: /srv/sentry
    - require:
        - virtualenv: /srv/sentry/

sentry:
  pip:
    - installed
    - name: sentry
    - bin_env: /srv/sentry
    - require:
        - virtualenv: /srv/sentry/
  user:
    - present
    - home: /srv/sentry/
    - uid: 989
    - shell: /bin/bash
  postgres_user:
    - present
    - require:
      - service: postgresql
  postgres_database:
    - present
    - owner: sentry
    - require:
        - postgres_user: sentry


/srv/sentry/sentry.conf.py:
  file:
    - managed
    - user: sentry
    - group: sentry
    - source: salt://sentry/sentry.conf.py
    - template: jinja
    - context:
        uri: http://sentry.{{ grains['domain'] }}
        from_email: sentry@{{ grains['fqdn'] }}
    - require:
        - file: /srv/sentry/

sentry_upgrade:
  cmd.wait:
    - name: /srv/sentry/bin/sentry --config=/srv/sentry/sentry.conf.py upgrade --noinput
    - user: sentry
    - group: sentry
    - watch:
        - pip: sentry
        - file: /srv/sentry/sentry.conf.py
    - require:
        - postgres_database: sentry

/etc/supervisor/conf.d/sentry.conf:
  file:
    - managed
    - source: salt://sentry/sentry_supervisor.conf
    - require:
        - pkg: supervisor
    - watch_in:
        - cmd: supervisor_reload

/etc/nginx/sites-enabled/sentry.conf:
  file:
    - managed
    - source: salt://sentry/sentry_nginx.conf
    - template: jinja
    - context:
        domain: sentry.{{ grains['domain'] }}
    - watch_in:
        - service: nginx