rsyslog:
  service:
    - running
    - enable: true    
    - reload: false
    - require:
      - pkg: rsyslog
    - watch:
      - pkg: rsyslog
  pkg:
    - installed

installed-packages-rsyslog:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - rsyslog
    - require_in:
      - file: /root/saltdoc/installed_packages.rst