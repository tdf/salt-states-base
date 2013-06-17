nginx:
  service:
    - running
    - enabled: true    
    - reload: true
    - require:
      - pkg: nginx
    - watch:
      - pkg: nginx
  pkg:
    - installed

www-data:
  alias.present:
    - target: root

