redis:
  pkg:
    - installed
    - name: redis-server
  service:
    - running
    - enable: True
    - name: redis-server