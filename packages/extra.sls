{% from 'packages/map.jinja' import packages with context %}

include:
  - requisites

{% if packages.extra %}
extra-packages:
  pkg.installed:
    - names:
{%- for pkg in packages.extra %}
      - {{ pkg }}
{%- endfor %}

installed-packages-packages-extra:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{%- for pkg in packages.extra %}
      - {{ pkg }}
{%- endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst

{% endif %}