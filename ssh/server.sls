openssh-server:
  pkg.installed:
    - names: 
      - openssh-server
      - openssh-blacklist

sshd:
  service.running:
    - name: ssh
    - enabled: true
    - require:
      - pkg: openssh-server
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/sshd_config
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: openssh-server
