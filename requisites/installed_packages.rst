Installed packages
==================

The following packages were installed by salt:
{% if accumulator|default(False) %}{% for line in accumulator['installed_packages'] %}
- {{ line }}{% endfor %}
{% endif %}
