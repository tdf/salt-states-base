# let quagga packages be installed
include:
  - quagga.service
  - quagga.zebra

# ebables ospf on all interfaces
/etc/quagga/debian.conf-ospf:
  file.sed:
    - before: '-A 127.0.0.1'
    - after: ''
    - limit: 'ospfd_options='
    - name: /etc/quagga/debian.conf
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# enable ospf daemon
/etc/quagga/daemons-ospf:
  file.sed:
    - before: 'no'
    - after: 'yes'
    - limit: '^ospfd='
    - name: /etc/quagga/daemons
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# create file ospfd.conf
/etc/quagga/ospfd.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
