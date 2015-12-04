include:
  - requisites

virtualenv:
  pkg:
    - installed
    - name: python-virtualenv

pip:
  pkg:
    - installed
    - name: python-pip

installed-packages-python:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - python-virtualenv
      - python-pip
    - require_in:
      - file: /root/saltdoc/installed_packages.rst