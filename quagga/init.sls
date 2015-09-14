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


/etc/quagga/debian.conf:
  file.blockreplace:
    - name: /etc/quagga/debian.conf
    - marker_start: "### START SALT MANAGED ZONE ###"
    - marker_end: "### END SALT MANAGED ZONE ###"
    - content: ''
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga

/etc/quagga/daemons:
  file.blockreplace:
    - name: /etc/quagga/daemons
    - marker_start: "### START SALT MANAGED ZONE ###"
    - marker_end: "### END SALT MANAGED ZONE ###"
    - content: ''
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
    - require:
      - pkg: quagga
    - watch_in:
      - service: quagga


installed-packages-quagga:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - quagga
    - require_in:
      - file: /root/saltdoc/installed_packages.rst