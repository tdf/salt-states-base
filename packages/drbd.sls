{% from 'packages/map.jinja' import packages with context %}

include:
  - requisites

{% if packages.drbd %}
drbd-packages:
  pkg.installed:
    - names:
{% for pkg in packages.drbd %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-drbd:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.drbd %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}