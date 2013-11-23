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

installed-packages-supervisor:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - supervisor
    - require_in:
      - file: /root/saltdoc/installed_packages.rst