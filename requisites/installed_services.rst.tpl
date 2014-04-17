Enabled services
================

The following services were installed by salt:
{% if accumulator|default(False) %}{% for line in accumulator['installed_services'] %}
- {{ line }}{% endfor %}
{% endif %}
