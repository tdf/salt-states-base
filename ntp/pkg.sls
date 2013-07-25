# installs and manage service for ntp
ntp:
  service:
    - running
    - require:
      - pkg: ntp
    - watch:
      - pkg: ntp
  pkg:
    - installed
    - names:
      - ntp
      - ntpdate
