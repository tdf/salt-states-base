{% from 'packages/map.jinja' import packages with context %}

include:
  - requisites

{% if packages.git %}
# Install git-Packages provided by pillar.sls
git-packages:
  pkg.installed:
    - names:
{% for pkg in packages.git %}
      - {{ pkg }}
{% endfor %}

installed-packages-package-git:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.git %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst

{% endif %}