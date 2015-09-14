shorewall:
  pkg:
    - installed
    - names:
      - shorewall
      - shorewall6
  service:
    - running
    - enable: True
    - require:
        - pkg: shorewall
    - watch:
        {% if grains['os'] == 'CentOS' %}
        - file: /etc/shorewall
        {% else %}
        - file: /etc/default/shorewall
        {% endif %}

{% if grains['os'] != 'CentOS'%}
/etc/default/shorewall:
  file:
    - managed
    - source: salt://shorewall/default_shorewall.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}
{% endif %}
