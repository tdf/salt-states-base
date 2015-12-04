include:
  - postgres
  - postgres.dev
  - python
  - python.dev
  - supervisor
  - nginx
  - requisites

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
      - sentry (PIP, Virtualenv /srv/sentry)
      - sentry[postgres] (PIP, Virtuelenv /srv/sentry)
    - require_in:
      - file: /root/saltdoc/installed_packages.rst

sentry:
  pip:
    - installed
    - names:
      - sentry[postgres]
      - sentry
    - bin_env: /srv/sentry
    - require:
        - virtualenv: /srv/sentry/
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
        uri: http://sentry.{{ grains['domain'] }}
        from_email: sentry@{{ grains['fqdn'] }}
    - require:
        - file: /srv/sentry/
        - pip: sentry

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
    - require:
        - pkg: nginx
    - watch_in:
        - service: nginx
