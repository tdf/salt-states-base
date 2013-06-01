core-packages:
  pkg:
    - installed
    - names:
      - bash-completion
      - dnsutils
      - ethtool
      - git
      - git-core
      - htop
      - iftop
      - iptraf
      - links
      - lsof
      - lynx
      - mc
      - nmap 
      - ntp
      - rsync
      - screen 
      - sipcalc
      - smartmontools
      - tcpdump 
      - tig
      - traceroute
      - unzip
      - vim 
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
