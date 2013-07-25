include:
  - ntp.pkg

# manages configuration of ntp
/etc/ntp.conf:
  file.managed:
    - source: salt://ntp/ntp.conf
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - require:
      - pkg: ntp
    - watch_in:
      - service: ntp
    - defaults:
      ntp_server: ['0.pool.ntp.org',
                   '1.pool.ntp.org',
                   '2.pool.ntp.org',
                   '3.pool.ntp.org']

