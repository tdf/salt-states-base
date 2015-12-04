{% from "ssh/map.jinja" import ssh with context %}
include:
  - requisites

# installs openssh client
openssh-client:
  pkg.installed:
    - names:
{% for pkg in ssh.client %}
      - {{ pkg }}
{% endfor %}

# installs predefines sshd config
/etc/ssh/ssh_config:
  file.managed:
    - source: salt://ssh/ssh_config
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: openssh-client

installed-packages-ssh-client:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in ssh.client %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst