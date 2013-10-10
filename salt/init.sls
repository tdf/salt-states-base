# Manages salt repository file
/etc/apt/sources.list.d/salt.list:
  file:
    - managed
    - source: salt://salt/salt.list.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}

{% if grains['os']|lower == 'debian' %}
salt-apt-key:
  cmd.run:
    - unless: apt-key list | grep joehealy
    - name: wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
{% endif %}
{% if grains['os']|lower == 'ubuntu' %}
salt-apt-key:
  cmd.run:
    - unless: apt-key list | grep joehealy
    - name: wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" apt-key add -
{% endif %}

# Local Variables:
# mode: yaml
# End:
