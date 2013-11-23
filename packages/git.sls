# Install git-Packages provided by pillar.sls
git-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_git', []) %}
      - {{ pkg }}
{% endfor %}

installed-packages-package-git:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in pillar.get('packages_git', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst