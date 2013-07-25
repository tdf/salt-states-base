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
