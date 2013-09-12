supervisor:
  pkg:
    - installed
  service:
    - running
    - enable: True

supervisor_reload:
  cmd:
    - wait
    - name: supervisorctl reload