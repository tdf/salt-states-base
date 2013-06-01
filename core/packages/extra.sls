extra-packages:
  pkg.installed:
    - names:
{%- for pkg in pillar.get('packages_extra', []) %}
      - {{ pkg }}
{%- endfor %}
