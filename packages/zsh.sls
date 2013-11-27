# Install zsh-Packages provided by pillar.sls
zsh-packages:
  pkg.installed:
    - names:
{% for pkg in pillar.get('packages_zsh', []) %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-zsh:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in pillar.get('packages_zsh', []) %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst