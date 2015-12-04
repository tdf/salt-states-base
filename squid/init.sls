include:
  - requisites

# installs squid3 and defines service
squid3:
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: squid3
    - watch:
      - pkg: squid3
  pkg:
    - installed


installed-packages-squid:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - squid3
    - require_in:
      - file: /root/saltdoc/installed_packages.rst