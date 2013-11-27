python-dev:
  pkg:
    - installed

installed-packages-python-dev:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - python-dev
    - require_in:
      - file: /root/saltdoc/installed_packages.rst