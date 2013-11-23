# Install net-Packages provided by pillar.sls
core-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_core', []) %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-core:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in pillar.get('packages_core', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst