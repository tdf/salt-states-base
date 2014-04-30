{% from 'packages/map.jinja' import packages with context %}

{% if packages.net %}
# Install net-Packages provided by pillar.sls
net-packages:
  pkg.installed:
    - names:
{% for pkg in packages.net %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-net:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.net %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}