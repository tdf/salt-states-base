# configures timezone on server. Default is 'Etc/UTC' but
# using pillar-data timezone other timezone can be selected
/etc/timezone:
  file.managed:
    - source: salt://core/timezone
    - template: jinja
    - context:
      timezone: {{ pillar.get('timezone', 'Etc/UTC')}}

# updates timezone on changing timezone file
dpkg-reconfigure -u tzdata:
  cmd.wait:
    - watch:
        - file: /etc/timezone
