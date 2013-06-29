/etc/timezone:
  file.managed:
    - source: salt://core/timezone
    - template: jinja
    - context:
      timezone: {{ pillar.get('timezone', 'Etc/UTC')}}

dpkg-reconfigure -u tzdata:
  cmd.wait:
    - watch:
        - file: /etc/timezone
