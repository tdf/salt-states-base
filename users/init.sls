# management of useraccounts
include:
  - users.profile

# change adduser not to create usergroups
/etc/adduser.conf_usergroups:
  file.sed:
    - name: /etc/adduser.conf
    - before: '^#*\s*USERGROUPS\s*=\s*.*$'
    - after: 'USERGROUPS=no'

# change dirmode for adduser
/etc/adduser.conf_dir_mode:
  file.sed:
    - name: /etc/adduser.conf
    - before: '^#*\s*DIR_MODE\s*=\s*.*$'
    - after: 'DIR_MODE=0711'

# change useradd not to create usergroups
/etc/login.defs:
  file.sed:
    - before: '^USERGROUPS_ENAB yes$' 
    - after: 'USERGROUPS_ENAB no'

# read out pillar-data and create useraccounts
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

# set ssh-keys for created users
{% for auth in args.get('ssh_auth', []) %}
{{ user }}_{{ auth['key'] }}:
  ssh_auth:
    - present
    - user: {{ user }}
    - name: {{ auth['key'] }}
    - enc: {{ auth['type'] }}
    - comment: {{ auth.get('comment', user)}}
    - require:
        - user: {{ user }}
{% endfor %}

# remove absent ssh-keys
{% for auth in args.get('absent_ssh_auth', []) %}
{{ auth }}: 
  ssh_auth:
    - absent
    - user: {{ user }}
{% endfor %}
{% endfor %}

# remove absent users
{% for user in pillar.get('absent_users', []) %}
{{ user }}:
  user.absent

{% endfor %}

