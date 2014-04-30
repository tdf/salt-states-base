{% from 'packages/map.jinja' import packages with context %}

{% if packages.lxc %}
# Install lxc-Packages provided by pillar.sls
lxc-packages:
  pkg.installed:
    - names:
{% for pkg in packages.lxc %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-lxc:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.lxc %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}