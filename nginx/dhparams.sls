{% from "nginx/map.jinja" import nginx with context %}
include:
  - nginx.server

nginx-ssl-include-dhparams:
  file:
    - accumulated
    - name: nginx-ssl-include
    - filename: {{nginx.include_dir}}/ssl
    - text: "ssl_dhparam {{ nginx.dhparams }};"
    - require_in:
      - file: nginx-include-dir