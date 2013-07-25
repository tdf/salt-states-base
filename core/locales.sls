# installs german manpages and on ubuntu german language pack
de-locale:
  pkg.installed:
    - pkgs:
      - manpages-de
{% if grains['os'] == 'Ubuntu' %}
      - language-pack-de
{% endif %}

# runs locale-gen if de-locale changes
locale-gen:
  cmd.wait:
    - watch:
      - pkg: de-locale
    - require:
      - pkg: debconf-utils

# updates locales of locale-gen runs
update-locale:
  cmd.wait:
    - name: update-locale LANG="en_US.UTF-8" LANGUAGE="en_US:en"
    - watch:
      - cmd: locale-gen
