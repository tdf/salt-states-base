supervisor:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: supervisor
supervisor_reload:
  cmd:
    - wait
    - name: supervisorctl reload
    - require:
        - service: supervisor

installed-packages-supervisor:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - supervisor
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
# Local Variables:
# mode: yaml
# End:
