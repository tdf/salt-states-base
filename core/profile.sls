/etc/profile.d/Z99-user.sh:
  file.managed:
    - source: salt://core/Z99-user.sh
    - user: root
    - group: root
    - mode: 0755
