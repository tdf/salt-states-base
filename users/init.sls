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

{% for user, args in pillar.get('users', {}).iteritems() %}
{{ user }}:
  user.present:
    - home: /home/{{ user }}
    - uid: {{ args['uid'] }}
    - fullname: {{ args['fullname'] }}
    - remove_groups: False
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

# SSH-Keys per User setzen
{% for auth in args.get('ssh_auth', []) %}
{{ auth['key'] }}:
  ssh_auth:
    - present
    - user: {{ user }}
    - enc: {{ auth['type'] }}
    - comment: {{ auth.get('comment', user)}}
    - require:
        - user: {{ user }}
{% endfor %}
{% for auth in args.get('absent_ssh_auth', []) %}
{{ auth }}: 
  ssh_auth:
    - absent
    - user: {{ user }}
{% endfor %}

{% endfor %}

{% for user in pillar.get('absent_users', []) %}
{{ user }}:
  user.absent
{% endfor %}

