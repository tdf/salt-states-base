# Install git-Packages provided by pillar.sls
git-packages:
  pkg.installed:
    - names:
{%- for pkg in pillar.get('packages_git', []) %}
      - {{ pkg }}
{%- endfor %}
