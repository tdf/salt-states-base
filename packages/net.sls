# Install net-Packages provided by pillar.sls
net-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_net', []) %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-net:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in pillar.get('packages_net', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst