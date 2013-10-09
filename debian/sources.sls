# installes dependend on installed os the needed sources.list
/etc/apt/sources.list:
  file.managed:
    - source: salt://debian/sources.list.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}
    - user: root
    - group: root
    - mode: 0644


# Local Variables:
# mode: yaml
# End:
