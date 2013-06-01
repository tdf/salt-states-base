openssh-client:
  pkg.installed

/etc/ssh/ssh_config:
  file.managed:
    - source: salt://ssh/ssh_config
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: openssh-client
