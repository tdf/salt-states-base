# Install pacemaker-Packages provided by pillar.sls
pacemaker-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_pacemaker', []) %}
      - {{ pkg }}
{% endfor %}
