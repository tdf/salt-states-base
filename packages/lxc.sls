# Install lxc-Packages provided by pillar.sls
lxc-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_lxc', []) %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-lxc:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in pillar.get('packages_lxc', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst