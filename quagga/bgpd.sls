# let quagga packages be installed
include:
  - quagga.service
  - quagga.zebra

# ebables bgp on all interfaces
/etc/quagga/debian.conf-bgp:
  file.sed:
    - before: '-A 127.0.0.1'
    - after: ''
    - limit: 'bgpd_options='
    - name: /etc/quagga/debian.conf
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# enable bgp daemon
/etc/quagga/daemons-bgp:
  file.sed:
    - before: 'no'
    - after: 'yes'
    - limit: '^bgpd='
    - name: /etc/quagga/daemons
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# create file bgpd.conf
/etc/quagga/bgpd.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
