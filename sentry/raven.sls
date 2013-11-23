include:
  - python

raven:
  pip:
    - installed

installed-packages-sentry-raven:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - raven
    - require_in:
      - file: /root/saltdoc/installed_packages.rst