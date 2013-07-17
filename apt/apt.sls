/etc/apt/apt.conf.d/999user:
  file.managed:
    - source: salt://apt/apt_999user
    - user: root
    - group: root
    - mode: 0644

