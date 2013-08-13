# installs openssh server and blacklist and defines service
ssh:
  service.running:
{% if grains['os_family'] == 'RedHat' %}
    - name: sshd
{% endif %}
    - enable: true
    - require:
      - pkg: openssh-server
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config
  pkg.installed:
    - names: 
      - openssh-server
      - openssh-blacklist

# configures sshd_config using predefined configuration
/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/sshd_config
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: openssh-server
