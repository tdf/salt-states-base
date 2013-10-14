/etc/apt/sources.list.d/backports.list:
  file:
    - managed
    - source: salt://debian/sources.list.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}.backports

# Local Variables:
# mode: yaml
# End:
