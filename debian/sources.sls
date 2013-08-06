# installes dependend on installed os the needed sources.list
/etc/apt/sources.list:
  file.managed:
{% if grains['os'] == 'Debian' %}

{% if grains['lsb_distrib_codename'] == 'wheezy' %}
    - source: salt://debian/sources.list.debian.wheezy
{% elif grains['lsb_distrib_codename'] == 'squeeze' %}
    - source: salt://debian/sources.list.debian.squeeze
{% endif %}

{% elif grains['os'] == 'Ubuntu' %}

{% if grains['lsb_distrib_codename'] == 'precise' %}
    - source: salt://debian/sources.list.ubuntu.precise
{% elif grains['lsb_distrib_codename'] == 'quantal' %}
    - source: salt://debian/sources.list.ubuntu.quantal
{% endif %}

{% endif %}
    - user: root
    - group: root
    - mode: 0644

