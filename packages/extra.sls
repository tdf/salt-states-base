extra-packages:
  pkg.installed:
    - names:
{%- for pkg in pillar.get('packages_extra', []) %}
      - {{ pkg }}
{%- endfor %}

installed-packages-packages-extra:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{%- for pkg in pillar.get('packages_extra', []) %}
      - {{ pkg }}
{%- endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst