include:
  - requisites

fail2ban:
  pkg: 
    - installed
  service:
    - running
    - enable: True

/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://fail2ban/jail.local
    - user: root
    - group: root
    - mode: 644
    - watch_in:
       - service: fail2ban
    - require:
       - pkg: fail2ban


installed-packages-fail2ban:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - fail2ban
    - require_in:
      - file: /root/saltdoc/installed_packages.rst