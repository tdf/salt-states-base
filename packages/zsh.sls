# Install zsh-Packages provided by pillar.sls
zsh-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_zsh', []) %}
      - {{ pkg }}
{% endfor %}
