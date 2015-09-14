# let quagga packages be installed
include:
  - quagga
  - quagga.zebra

# ebables ospf on all interfaces
quagga-enable-ospf-all:
  file.accumulated:
    - filename: /etc/quagga/debian.conf
    - text: 'ospfd_options="--daemon"'
    - require_in:
      - file: /etc/quagga/debian.conf

# enable ospf daemon
quagga-enable-ospf-daemon:
  file.accumulated:
    - filename: /etc/quagga/daemons
    - text: "ospfd=yes"
    - require_in:
      - file: /etc/quagga/daemons

# create file ospfd.conf
/etc/quagga/ospfd.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
