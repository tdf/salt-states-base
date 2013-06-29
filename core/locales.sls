de-locale:
  pkg.installed:
    - pkgs:
      - manpages-de
{% if grains['os'] == 'Ubuntu' %}
      - language-pack-de
{% endif %}

locale-gen:
  cmd.wait:
    - watch:
      - pkg: de-locale

update-locale:
  cmd.wait:
    - name: update-locale LANG="en_US.UTF-8" LANGUAGE="en_US:en"
    - watch:
      - cmd: locale-gen

