include:
  - requisites

# installs sudo
sudo:
  pkg.installed

# manages sudoers
/etc/sudoers:
    file.managed:
     - source: salt://util/sudoers
     - user: root
     - group: root
     - mode: 0440
     - require:
       - pkg: sudo

installed-packages-util-sudo:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - sudo
    - require_in:
      - file: /root/saltdoc/installed_packages.rst
