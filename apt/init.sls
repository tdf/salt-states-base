{% if grains['os_family'] == 'Debian' %}
# includes apt-modules for installing and configuring apt-stuff
include:
  - apt.apt
  - apt.apticron
  - apt.apt-listchanges
{% endif %}