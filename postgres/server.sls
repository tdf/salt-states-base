# define postgresql service and installs needed postgresql pakages
postgresql:
  service:
    - running
    - enabled: true    
    - reload: true
    - require:
      - pkg: postgresql
    - watch:
      - pkg: postgresql
  pkg:
    - installed

