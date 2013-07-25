# installs nginx server and configuring service for nginx
nginx:
  service:
    - running
    - enabled: true    
    - reload: true
    - require:
      - pkg: nginx
    - watch:
      - pkg: nginx
  pkg:
    - installed

# defines mail-alias from www-data to root
www-data:
  alias.present:
    - target: root

