# Install git-Packages provided by pillar.sls
core-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_core', []) %}
      - {{ pkg }}
{% endfor %}
