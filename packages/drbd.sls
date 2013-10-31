# Install drbd-Packages provided by pillar.sls
drbd-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_drbd', []) %}
      - {{ pkg }}
{% endfor %}
