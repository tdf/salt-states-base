{% if grains['os_family'] == 'Debian' %}
gitlab-ce-deps:
  pkg:
    - installed
    - pkgs:
      - apt-transport-https
      {% if grains['osfullname'] == 'Debian' %}
      - debian-archive-keyring
      {% endif %}
gitlab-ce:
  pkgrepo:
    - managed
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/{{ grains['osfullname'] | lower }}/ {{ grains['oscodename']}} main
    - key_url: https://packages.gitlab.com/gpg.key
    - require:
      - pkg: gitlab-ce-deps
  pkg:
    - installed
    - require:
      - pkgrepo: gitlab-ce
    - update: True
{% endif %}