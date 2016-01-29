{% if grains['os_family'] == 'Debian' %}
docker-engine-deps:
  pkg:
    - installed
    - pkgs:
      - apt-transport-https
docker-engine:
  pkgrepo:
    - managed
    - name: deb https://apt.dockerproject.org/repo {{ grains['osfullname'] | lower }}-{{ grains['oscodename']}} main
    - key_id: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: hkp://p80.pool.sks-keyservers.net:80
    - require:
      - pkg: docker-engine-deps
  pkg:
    - installed
    - require:
      - pkgrepo: docker-engine
    - update: True
{% endif %}