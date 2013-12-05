# installs openssh server and blacklist and defines service
openssh-server:
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
{% for pkg in pillar.get('packages_ssh_server', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
