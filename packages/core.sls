{% from 'packages/map.jinja' import packages with context %}

{% if packages.core %}
core-packages:
  pkg.installed:
    - names:
{% for pkg in packages.core %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-core:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.core %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}