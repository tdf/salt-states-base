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

installed-packages-quagga:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - quagga
    - require_in:
      - file: /root/saltdoc/installed_packages.rst