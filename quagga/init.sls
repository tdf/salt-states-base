quagga:
  service:
    - running
    - enable: true
    - sig: quagga
    - require:
      - pkg: quagga
    - watch:
      - pkg: quagga
  pkg.installed:
    - name: quagga

