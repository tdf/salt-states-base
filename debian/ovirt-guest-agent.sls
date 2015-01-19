# http://www.ovirt.org/Feature/GuestAgentDebian
/etc/apt/sources.list.d/ovirt-guest-agent.list:
  file:
    - managed
    - source: salt://debian/sources.list.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}.ovirt-guest-agent

{% if grains['lsb_distrib_codename']|lower == 'wheezy' %}
ovirt-guest-agent-apt-key:
  cmd.run:
    - unless: apt-key list | grep 73A1A299
    - name: wget -q -O- "http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/Release.key" | apt-key add -
{% endif %}

ovirt-guest-agent:
  pkg:
    - installed
  service:
    - running
    - enable: True

# Local Variables:
# mode: yaml
# End:
