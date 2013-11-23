# Install drbd-Packages provided by pillar.sls
drbd-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_drbd', []) %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-drbd:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in pillar.get('packages_drbd', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst