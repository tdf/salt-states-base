# root SSH-Key Management
{% for user, args in pillar.get('users', {}).iteritems() %}
{% for auth in args.get('ssh_auth', []) %}
{{ auth['key'] }}_root_ssh_auth:
  ssh_auth:
    - present
    - user: root
    - enc: {{ auth['type'] }}
    - comment: {{ auth.get('comment', user) }}
    - name: {{ auth['key'] }}
{% endfor %}
{% endfor %}

{% for user, args in pillar.get('users', {}).iteritems() %}
{% for auth in args.get('absent_ssh_auth', []) %}
{{ auth['key'] }}_root_ssh_auth:
  ssh_auth:
    - absent
    - user: root
    - name: {{ auth['key'] }}
{% endfor %}
{% endfor %}

{% for auth in pillar.get('absent_root_ssh_auth', []) %}
{{ auth }}_root_ssh_auth:
  ssh_auth:
    - absent
    - user: root
    - name: {{ auth }}
{% endfor %}