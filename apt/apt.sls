# sets configuration for apt. Here we set http and ftp timeout
/etc/apt/apt.conf.d/999user:
  file.managed:
    - source: salt://apt/apt_999user
    - user: root
    - group: root
    - mode: 0644

