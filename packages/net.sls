# Install net-Packages provided by pillar.sls
net-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_net', []) %}
      - {{ pkg }}
{% endfor %}
