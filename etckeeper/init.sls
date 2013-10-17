include:
  - packages.git

etckeeper:
  pkg: 
    - installed
    - require:
      - pkg: git-packages

/etc/etckeeper/etckeeper.conf:
  file.managed:
    - source: salt://etckeeper/etckeeper.conf
    - user: root
    - group: root
    - mode: 644
    - require:
       - pkg: etckeeper

/usr/bin/etckeeper init; /usr/bin/etckeeper commit "Initial commit":
  cmd.run:
    - require:
       - pkg: etckeeper
       - file: /etc/etckeeper/etckeeper.conf
    - unless: test -d /etc/.git
