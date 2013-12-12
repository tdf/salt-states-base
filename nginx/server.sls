# installs nginx server and configuring service for nginx
nginx:
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: nginx
    - watch:
      - pkg: nginx
  pkg:
    - installed

# defines mail-alias from www-data to root
www-data_nginx:
  alias.present:
    - target: root

installed-packages-nginx-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - nginx
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
