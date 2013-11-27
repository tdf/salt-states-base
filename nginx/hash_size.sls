/etc/nginx/conf.d/hash_size.conf:
  file.managed:
    - source: salt://nginx/hash_size.conf
    - watch_in:
        - service: nginx