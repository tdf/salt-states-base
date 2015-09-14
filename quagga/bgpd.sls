# let quagga packages be installed
include:
  - quagga
  - quagga.zebra

# enables bgp on all interfaces

quagga-enable-bgp-all:
  file.accumulated:
    - filename: /etc/quagga/debian.conf
    - text: 'bgpd_options="--daemon"'
    - require_in:
      - file: /etc/quagga/debian.conf

# enable bgp daemon
quagga-enable-bgp-daemon:
  file.accumulated:
    - filename: /etc/quagga/daemons
    - text: "bgpd=yes"
    - require_in:
      - file: /etc/quagga/daemons

# create file bgpd.conf
/etc/quagga/bgpd.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
