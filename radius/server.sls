radius-server:
  pkg.installed:
    - name: freeradius

freeradius:
  service.running:
    - enabled: true
    - watch:
      - file: /etc/freeradius/clients.conf
      - file: /etc/freeradius/proxy.con
      - file: /etc/freeradius/users
    - require:
      - pkg: radius-server
