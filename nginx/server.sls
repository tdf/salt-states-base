{% from "nginx/map.jinja" import nginx with context %}

include:
  - requisites

# installs nginx server and configuring service for nginx
nginx:
  service:
    - running
    - name: {{ nginx.service }}
    - enable: true    
    - reload: true
    - require:
      - pkg: nginx
    - watch:
      - pkg: nginx
      - file: nginx-include-dir
  pkg:
    - installed
    - name: {{ nginx.server }}


nginx-include-dir:
  file:
    - recurse
    - name: {{ nginx.include_dir }}
    - source: salt://nginx/includes
    - template: jinja
    - require:
      - pkg: nginx

nginx-ssl-include:
  file:
    - accumulated
    - filename: {{nginx.include_dir}}/ssl
    - text: ''
    - require_in:
      - file: nginx-include-dir

{% set alias = salt['pillar.get']('nginx:alias', 'root') %} # '
{% if alias %}
# defines mail-alias from www-data to root
{{ nginx.user }}:
  alias.present:
    - target: {{ alias }}
{% endif %}

installed-packages-nginx-server:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ nginx.server }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst

installed-services-nginx-server:
  file.accumulated:
    - name: installed_services
    - filename: /root/saltdoc/installed_services.rst
    - text:
      - {{ nginx.service }}
    - require_in:
      - file: /root/saltdoc/installed_services.rst
