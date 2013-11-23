{% if grains['os_family'] == "Debian" %}
debconf-utils:
  pkg.installed:
    - order: 1
{% endif %}

/root/saltdoc:
  file.directory

/root/saltdoc/installed_packages.rst:
  file.managed:
    - source: salt://requisites/installed_packages.rst.tpl
    - template: jinja
    - require:
      - file: /root/saltdoc

installed-packages-requisites:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - debconf-utils
    - require_in:
      - file: /root/saltdoc/installed_packages.rst