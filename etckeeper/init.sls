{% from 'etckeeper/map.jinja' include etckeeper with context %}

include:
  - packages.git
  - requisites

etckeeper:
  pkg: 
    - installed
    - name: {{ etckeeper.etckeeper }}
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

installed-packages-etckeeper:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ etckeeper.etckeeper }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst