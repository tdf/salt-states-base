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