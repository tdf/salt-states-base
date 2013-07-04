core-packages:
  pkg:
    - installed
    - names:
      - bash-completion
      - debconf-utils
      - dnsutils
      - ethtool
      - findutils
      - git
      - git-core
      - htop
      - iftop
      - iptraf
      - links
      - lsof
      - lynx
      - mc
      - mlocate
      - nmap 
      - ntp
      - pwgen
      - rsync
      - sipcalc
      - smartmontools
      - tcpdump 
      - telnet
      - tig
      - traceroute
      - unzip
      - vlan
      - vnstat
      - wget
      - whois
      - zip
{% if grains['os'] == 'Debian' %}
      - ifenslave
{% elif grains['os'] == 'Ubuntu' %}
      - ifenslave-2.6
{% endif %}
