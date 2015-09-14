# let quagga packages be installed
include:
  - quagga
  - quagga.zebra

# ebables rip on all interfaces
quagga-enable-rip-all:
  file.accumulated:
    - filename: /etc/quagga/debian.conf
    - text: 'ripd_options="--daemon"'
    - require_in:
      - file: /etc/quagga/debian.conf

# enable rip daemon
quagga-enable-rip-daemon:
  file.accumulated:
    - filename: /etc/quagga/daemons
    - text: "ripd=yes"
    - require_in:
      - file: /etc/quagga/daemons

# create file ripd.conf
/etc/quagga/ripd.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
