include:
  - requisites

# make sure, locales is installed
locales:
  pkg.installed

{% set shortlang = pillar.get('lang', 'de') %}

# installs german manpages and on ubuntu german language pack
{{ shortlang }}-locale:
  pkg.installed:
    - pkgs:
      - manpages-{{ shortlang }}
{% if grains['os'] == 'Ubuntu' %}
      - language-pack-{{ shortlang }}
{% endif %}
    - require:
      - pkg: locales

# runs locale-gen if de-locale changes
locale-gen:
  cmd.wait:
    - watch:
      - pkg: {{ shortlang }}-locale
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
/etc/default/keyboard:
  file.managed:
    - source: salt://locales/{{ shortlang }}.keyboard.{{ grains['os']|lower }}
    - user: root
    - group: root
    - mode: 0644


installed-packages-locales:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - locales
    - require_in:
      - file: /root/saltdoc/installed_packages.rst