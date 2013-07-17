/etc/apt/apt.conf.d/999user:
  file.managed:
    - source: salt://core/apt_999user
    - user: root
    - group: root
    - mode: 0644

