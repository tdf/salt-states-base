# installs freeradius and defines service for managing radius
freeradius:
  service.running:
    - enabled: true
    - watch:
      - file: /etc/freeradius/clients.conf
      - file: /etc/freeradius/proxy.con
      - file: /etc/freeradius/users
    - require:
      - pkg: radius-server
  pkg.installed


installed-packages-radius-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - radius-server
    - require_in:
      - file: /root/saltdoc/installed_packages.rst