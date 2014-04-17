{% if grains['os_family'] == "Debian" %}
debconf-utils:
  pkg.installed:
    - order: 1

installed-packages-requisites:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - debconf-utils
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
{% endif %}

/root/saltdoc:
  file.directory

/root/saltdoc/installed_packages.rst:
  file.managed:
    - source: salt://requisites/installed_packages.rst.tpl
    - template: jinja
    - require:
      - file: /root/saltdoc

/root/saltdoc/installed_services.rst:
  file.managed:
    - source: salt://requisites/installed_services.rst.tpl
    - template: jinja
    - require:
      - file: /root/saltdoc

