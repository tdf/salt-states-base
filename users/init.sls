# User-Verwaltung
#
# Die Userverwaltung liest die pillar users aus, und pflegt anhand dieser Daten
# die User im System.
#

/etc/adduser.conf_usergroups:
  file.sed:
    - name: /etc/adduser.conf
    - before: '^#*\s*USERGROUPS\s*=\s*.*$'
    - after: 'USERGROUPS=no'

/etc/adduser.conf_dir_mode:
  file.sed:
    - name: /etc/adduser.conf
    - before: '^#*\s*DIR_MODE\s*=\s*.*$'
    - after: 'DIR_MODE=0711'

{% for user, args in pillar['users'].iteritems() %}
{% if 'present' in args %}
{{ user }}:
  user.present:
    - home: /home/{{ user }}
    - uid: {{ args['uid'] }}
    - fullname: {{ args['fullname'] }}
    {% if 'shell' in args %}
    - shell: {{ args['shell'] }}
    {% endif %}
    {% if 'groups' in args %}
    - optional_groups:
      {% for group in args['groups'] %}
      - {{ group }}
      {% endfor %}
    {% endif %}
    {% if 'password' in args %}
    - password: {{ args['password']}}
    {% endif %}
{% elif 'present' not in args %}
{{ user }}:
  user.absent
{% endif %}

# SSH-Keys per User setzen
{% if 'ssh_auth' in args %}
{% for auth in args['ssh_auth'] %}
{% if 'present' in args %}
{{ auth['key'] }}:
  ssh_auth:
    - present
    - user: {{ user }}
    - enc: {{ auth['type'] }}
    - comment: {{ auth.get('comment', user)}}
{% endif %}
{% endfor %}
{% endif %}

{% endfor %}

