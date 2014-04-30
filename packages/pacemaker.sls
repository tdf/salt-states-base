{% from 'packages/map.jinja' import packages with context %}

{% if packages.pacemaker %}
# Install pacemaker-Packages provided by pillar.sls
pacemaker-packages:
  pkg.installed:
    - names:
{% for pkg in packages.pacemaker %}
      - {{ pkg }}
{% endfor %}

installed-packages-packages-pacemaker:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
{% for pkg in packages.pacemaker %}
      - {{ pkg }}
{% endfor %}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}