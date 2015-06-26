
# Installing ClamAV
###################

freshclam:
  cmd.wait:
    - watch:
        - pkg: clamav-daemon

clamav-freshclam:
  service:
    - running
    - enable: True
    - require:
        - pkg: clamav-daemon

clamav-daemon:
  service:
    - running
    - enable: True
    - watch:
        - cmd: amavis_genrsa
  pkg:
    - installed
    - debconf: salt://debconf/clamav-freshclam

