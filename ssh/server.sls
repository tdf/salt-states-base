{% from "ssh/map.jinja" import ssh with context %}
# installs openssh server and blacklist and defines service
openssh-server:
  pkg.installed:
    - names:
{% for pkg in ssh.server %}
      - {{ pkg }}
{% endfor %}

ssh:
  service.running:
    - name: {{ ssh.server_service }}
    - enable: True
    - require:
      - pkg: openssh-server
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config

# configures sshd_config using predefined configuration
/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/sshd_config
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - require:
      - pkg: openssh-server


installed-packages-ssh-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in ssh.server %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
