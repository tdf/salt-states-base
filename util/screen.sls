include:
  - requisites

# installs screen
screen:
  pkg.installed

# manages screenrc using predefined values
/etc/screenrc:
    file.managed:
     - source: salt://util/screenrc
     - user: root
     - group: root
     - mode: 0644
     - require:
       - pkg: screen

installed-packages-screen:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - screen
    - require_in:
      - file: /root/saltdoc/installed_packages.rst