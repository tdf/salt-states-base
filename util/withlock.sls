# manages sudoers
/usr/local/bin/withlock:
    file.managed:
     - source: salt://util/withlock.py
     - user: root
     - group: root
     - mode: 0755
