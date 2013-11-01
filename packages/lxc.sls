# Install lxc-Packages provided by pillar.sls
lxc-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_lxc', []) %}
      - {{ pkg }}
{% endfor %}
