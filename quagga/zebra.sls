# let quagga packages be installed
include:
  - quagga.service

# ebables zebra on all interfaces
/etc/quagga/debian.conf-zebra:
  file.sed:
    - before: '-A 127.0.0.1'
    - after: ''
    - limit: 'zebra_options='
    - name: /etc/quagga/debian.conf
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# enable zebra daemon
/etc/quagga/daemons-zebra:
  file.sed:
    - before: 'no'
    - after: yes
    - limit: '^zebra='
    - name: /etc/quagga/daemons
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# Create file zebra.conf
/etc/quagga/zebra.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
