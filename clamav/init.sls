
# Installing ClamAV
###################

freshclam &:
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
  pkg:
    - installed
    - debconf: salt://clamav/clamav-freshclam.debconf

