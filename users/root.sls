# root SSH-Key Management
root:
  ssh_auth:
    - present
    - user: root
    - enc: ssh-rsa
    - comment: no-comment
    - names:
{% for user, args in pillar['users'].iteritems() %}
{% if 'present' in args %}
{% if 'ssh_auth' in args %}
{% for auth in args['ssh_auth'] %}
      - {{ auth['type'] }} {{ auth['key'] }}  {{ auth.get('comment', user)}}
{% endfor %}
{% endif %}
{% endif %}
{% endfor %}

{% for user, args in pillar['users'].iteritems() %}
{% if 'present' not in args %}
{% for auth in args['ssh_auth'] %}
{{ auth['key'] }}:
  ssh_auth:
    - absent
    - user: root
{% endfor %}
{% endif %}
{% endfor %}

