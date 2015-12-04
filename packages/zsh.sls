{% from 'packages/map.jinja' import packages with context %}

include:
  - requisites

{% if packages.zsh %}
# Install zsh-Packages provided by pillar.sls
zsh-packages:
  pkg.installed:
    - names:
{% for pkg in packages.zsh %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-zsh:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.zsh %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}