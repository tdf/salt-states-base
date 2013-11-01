# installs openssh server and blacklist and defines service
openssh-server-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_ssh_server', []) %}
      - {{ pkg }}
{% endfor %}

ssh:
  service.running:
{% if grains['os_family'] == 'RedHat' %}
    - name: sshd
{% endif %}
    - enable: true
    - require:
      - pkg: openssh-server-packages
    - watch:
      - pkg: openssh-server-packages
      - file: /etc/ssh/sshd_config

# configures sshd_config using predefined configuration
/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/sshd_config
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: openssh-server
