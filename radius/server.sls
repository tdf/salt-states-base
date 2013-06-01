radius-server:
  pkg.installed:
    - names: 
      - freeradius

freeradius:
  service.running:
    - name: freeradius
    - enabled: true
    - watch:
      - file: /etc/freeradius/clients.conf
      - file: /etc/freeradius/proxy.con
      - file: /etc/freeradius/users
