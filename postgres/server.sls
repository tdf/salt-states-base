# define postgresql service and installs needed postgresql pakages
postgresql:
  service:
    - running
    - enable: true    
    - reload: true
    - require:
      - pkg: postgresql
    - watch:
      - pkg: postgresql
  pkg:
    - installed

