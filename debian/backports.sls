backports:
  file:
    - managed
    - name: /etc/apt/sources.list.d/backports.list
    - source: salt://debian/sources.list.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}.backports

# Local Variables:
# mode: yaml
# End:
