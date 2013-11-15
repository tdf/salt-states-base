# let quagga packages be installed
include:
  - quagga
  - quagga.zebra

# ebables rip on all interfaces
/etc/quagga/debian.conf-rip:
  file.sed:
    - before: '-A 127.0.0.1'
    - after: ''
    - limit: 'ripd_options='
    - name: /etc/quagga/debian.conf
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# enable rip daemon
/etc/quagga/daemons-rip:
  file.sed:
    - before: 'no'
    - after: 'yes'
    - limit: '^ripd='
    - name: /etc/quagga/daemons
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

# create file ripd.conf
/etc/quagga/ripd.conf:
  file.exists:
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga
