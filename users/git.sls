# manage git .gitconfig for users
{% for user, args in pillar.get('users', {}).iteritems() %}
/home/{{ user}}/.gitconfig:
  file.managed:
    - source: salt://users/gitconfig
    - user: {{ user }}
    - group: users
    - mode: 0644
    - template: jinja
    - context: 
      email: {{ args['email'] }}
      fullname: {{ args['fullname'] }}
    - require:
      - user: {{ user }}
{% endfor %}
