include:
  - postgres
  - postgres.dev
  - python
  - python.dev
  - supervisor
  - nginx
  - requisites

/srv/sentry/venv:
  virtualenv.managed:
    - system_site_packages: False
    - user: sentry
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


sentry-packages:
  pkg.installed:
    - names:
      - libxml2-dev
      - libxslt1-dev
      - libffi-dev
    - require:
      - pkg: python-dev


installed-packages-sentry-virtualenv:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - libxml2-dev
      - libxslt1-dev
      - libffi-dev
      - sentry (PIP, Virtualenv /srv/sentry/venv)
      - sentry[postgres] (PIP, Virtuelenv /srv/sentry/venv)
      - psycopg2 (PIP, Virtualenv /srv/sentry/venv)
    - require_in:
      - file: /root/saltdoc/installed_packages.rst

sentry:
  pip:
    - installed
    - names:
      - sentry[postgres]
      - sentry
      - psycopg2
    - bin_env: /srv/sentry/venv
    - require:
        - virtualenv: /srv/sentry/venv
  user:
    - present
    - home: /srv/sentry/
    - uid: 989
    - gid: 989
    - shell: /bin/bash
    - require:
      - group: sentry
  group:
    - present
    - gid: 989
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
        uri: http://{{ grains['fqdn'] }}
        from_email: sentry@{{ grains['fqdn'] }}
    - require:
        - user: sentry
        - pip: sentry

sentry_upgrade:
  cmd.wait:
    - name: /srv/sentry/venv/bin/sentry upgrade --noinput
    - user: sentry
    - group: sentry
    - env:
        - SENTRY_CONF: '/srv/sentry/sentry.conf.py'
    - watch:
        - pip: sentry
        - file: /srv/sentry/sentry.conf.py
    - require:
        - postgres_database: sentry

sentry_createuser:
  cmd.wait:
    - name: /srv/sentry/venv/bin/sentry createuser --email=sentry@{{ grains['fqdn'] }} --password=sentry --no-input --superuser
    - user: sentry
    - group: sentry
    - env:
        - SENTRY_CONF: '/srv/sentry/sentry.conf.py'
    - watch:
        - cmd: sentry_upgrade

sentry_cleanup:
  cron.present:
    - user: root
    - name: SENTRY_CONF='/srv/sentry/sentry.conf.py' /srv/sentry/venv/bin/sentry cleanup --days=30
    - minute: 0
    - hour: 3

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
        domain: {{ grains['fqdn'] }}
    - require:
        - pkg: nginx
    - watch_in:
        - service: nginx