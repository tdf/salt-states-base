{% from "nginx/map.jinja" import nginx with context %}

{% for cert, args in pillar.get('nginx:certs', {}).iteritems() %} #'
nginx-include-cert-{{ cert }}:
  file:
    - managed
    - name: {{ nginx.include-dir }}/ssl.{{ cert }}
    - source: salt://nginx/cert.tpl
    - template: jinja
    - defaults:
        ocsp: False
    - context:
        crt: {{ args['crt'] }}
        key: {{ args['key'] }}
        {% if args.get('ocsp', False) %}
        ocsp: {{ args['ocsp'] }}
        {% endif%}

{% endfor %}