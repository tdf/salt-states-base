# let quagga packages be installed
include:
  - quagga

# enables zebra on all interfaces
quagga-enable-zebra-all:
  file.accumulated:
    - filename: /etc/quagga/debian.conf
    - text: 'zebra_options="--daemon"'
    - require_in:
      - file: /etc/quagga/debian.conf

# enable zebra daemon
quagga-enable-zebra-daemon:
  file.accumulated:
    - filename: /etc/quagga/daemons
    - text: "zebra=yes"
    - require_in:
      - file: /etc/quagga/daemons

# Create file zebra.conf
/etc/quagga/zebra.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
