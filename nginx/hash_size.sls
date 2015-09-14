include:
  - nginx.server
/etc/nginx/conf.d/hash_size.conf:
  file.managed:
    - source: salt://nginx/hash_size.conf
    - require:
        - pkg: nginx
    - watch_in:
        - service: nginx