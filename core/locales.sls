# make sure, locales is installed
locales:
  pkg.installed

# installs german manpages and on ubuntu german language pack
de-locale:
  pkg.installed:
    - pkgs:
      - manpages-de
{% if grains['os'] == 'Ubuntu' %}
      - language-pack-de
{% endif %}
    - require:
      - pkg: locales

# runs locale-gen if de-locale changes
locale-gen:
  cmd.wait:
    - watch:
      - pkg: de-locale
    - require:
      - pkg: debconf-utils
      - pkg: locales

# updates locales of locale-gen runs
update-locale:
  cmd.wait:
    - name: update-locale LANG="en_US.UTF-8" LANGUAGE="en_US:en"
    - watch:
      - cmd: locale-gen

# manages german keyboard layout
{% if grains['os'] == 'Debian' %}
/etc/default/keyboard:
  file.managed:
    - source: salt://core/keyboard.debian
    - user: root
    - group: root
    - mode: 0644
{% endif %}
{% if grains['os'] == 'Ubuntu' %}
/etc/default/keyboard:
  file.managed:
    - source: salt://core/keyboard.ubuntu
    - user: root
    - group: root
    - mode: 0644
{% endif %}
